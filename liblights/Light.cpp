/*
 * Copyright (C) 2018-2019 SHIFT GmbH
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "Light.h"

#include <android-base/logging.h>

#define LIGHTS_DBG_ON 1

namespace {

using android::hardware::light::V2_0::LightState;
using android::hardware::light::V2_0::Type;

static uint32_t rgbToBrightness(const LightState& state) {
    uint32_t color = state.color & 0x00ffffff;
    return ((77 * ((color >> 16) & 0xff)) + (150 * ((color >> 8) & 0xff)) +
            (29 * (color & 0xff))) >> 8;
}

static bool isLit(const LightState& state) {
    return (state.color & 0x00ffffff);
}

static std::string type2str(Type type) {
    switch(type) {
    case Type::ATTENTION:
        return std::string("ATTENTION");

    case Type::BACKLIGHT:
        return std::string("BACKLIGHT");

    case Type::BATTERY:
        return std::string("BATTERY");

    case Type::NOTIFICATIONS:
        return std::string("NOTIFICATIONS");

    default:
        return std::string("UNKNOWN");
    }
}

}  // anonymous namespace

namespace android {
namespace hardware {
namespace light {
namespace V2_0 {
namespace implementation {

Light::Light(std::ofstream&& lcd_backlight, std::ofstream&& led_brightness,
             std::ofstream&& led_flash_mode, std::ofstream&& led_flash_period)
    : mLcdBacklight(std::move(lcd_backlight)),
      mLedBrightness(std::move(led_brightness)),
      mLedFlashMode(std::move(led_flash_mode)),
      mLedFlashPeriod(std::move(led_flash_period)) {

    auto attnFn(std::bind(&Light::setAttentionLight, this, std::placeholders::_1));
    auto backlightFn(std::bind(&Light::setLcdBacklight, this, std::placeholders::_1));
    auto batteryFn(std::bind(&Light::setBatteryLight, this, std::placeholders::_1));
    auto notifFn(std::bind(&Light::setNotificationLight, this, std::placeholders::_1));
    mLights.emplace(std::make_pair(Type::ATTENTION, attnFn));
    mLights.emplace(std::make_pair(Type::BACKLIGHT, backlightFn));
    mLights.emplace(std::make_pair(Type::BATTERY, batteryFn));
    mLights.emplace(std::make_pair(Type::NOTIFICATIONS, notifFn));
}

// Methods from ::android::hardware::light::V2_0::ILight follow.
Return<Status> Light::setLight(Type type, const LightState& state) {
    auto it = mLights.find(type);

    if (it == mLights.end()) {
        return Status::LIGHT_NOT_SUPPORTED;
    }

    LOG(ERROR) << __FUNCTION__ << ": Type(" << type2str(type) << ") Color("
               << std::hex << state.color << ")";

    it->second(state);

    return Status::SUCCESS;
}

Return<void> Light::getSupportedTypes(getSupportedTypes_cb _hidl_cb) {
    std::vector<Type> types;

    for (auto const& light : mLights) {
        types.push_back(light.first);
    }

    _hidl_cb(types);

    return Void();
}

bool Light::isLowBattery() {
    std::ifstream batt("/sys/class/power_supply/battery/capacity");
    std::string buffer;
    bool ret = false;
    int bat_level = 0;

    if (batt) {
        batt >> buffer;
        batt.close();

        bat_level = std::stoi(buffer);
        LOG(ERROR) << __FUNCTION__ << ": buffer(" << buffer << ") bat_level(" << bat_level << ")";
        if (bat_level <= 15) {
            return true;
        }
    } else {
        LOG(ERROR) << __FUNCTION__ << ": Could not read battery capacity";
    }

    return ret;
}

void Light::setAttentionLight(const LightState& state) {
    std::lock_guard<std::mutex> lock(mLock);
    mAttentionState = state;
    setSpeakerBatteryLightLocked();
}

void Light::setLcdBacklight(const LightState& state) {
    std::lock_guard<std::mutex> lock(mLock);
    mBacklightState = state;
    uint32_t brightness = rgbToBrightness(state);
    mLcdBacklight << brightness << std::endl;

    // update leds
    setSpeakerBatteryLightLocked();
}

void Light::setBatteryLight(const LightState& state) {
    std::lock_guard<std::mutex> lock(mLock);
    mBatteryState = state;
    LOG(ERROR) << __FUNCTION__ << ": Color(" << std::hex << state.color << ")";
    setSpeakerBatteryLightLocked();
}

void Light::setNotificationLight(const LightState& state) {
    std::lock_guard<std::mutex> lock(mLock);
    mNotificationState = state;
    setSpeakerBatteryLightLocked();
}

void Light::setSpeakerBatteryLightLocked() {
    LOG(ERROR) << __FUNCTION__ << ": Notification lit(" << isLit(mNotificationState)
               << ") Attention lit(" << isLit(mAttentionState) << ") Battery lit("
               << isLit(mBatteryState) << ")";

    LOG(ERROR) << __FUNCTION__ << ": isLowBattery(" << isLowBattery() << ")";

    // Don't update notification lights on low battery
    if (!isLowBattery()) {
        if (isLit(mNotificationState)) {
            setSpeakerLightLocked(mNotificationState);
        } else if (isLit(mAttentionState)) {
            setSpeakerLightLocked(mAttentionState);
        } else if (isLit(mBatteryState)) {
            setSpeakerLightLocked(mBatteryState);
        } else {
            // Lights off
            LOG(ERROR) << __FUNCTION__ << ": Turn off lights";
            mLedBrightness << "0:0:0" << std::endl;
        }
    } else {
        if (isLit(mBatteryState)) {
            setSpeakerLightLocked(mBatteryState);
        } else {
            // Lights off
            LOG(ERROR) << __FUNCTION__ << ": Turn off lights";
            mLedBrightness << "0:0:0" << std::endl;
        }
    }
}

void Light::setSpeakerLightLocked(const LightState& state) {
    uint32_t alpha, red, green, blue;
    uint32_t colorRGB = state.color;

    mLedFlashMode << (uint32_t) state.flashMode << std::endl;
    mLedFlashPeriod << state.flashOnMs << ":" << state.flashOffMs << std::endl;

    alpha = (colorRGB >> 24) & 0xFF;
    if (alpha) {
        red = (colorRGB >> 16) & 0xFF;
        green = (colorRGB >> 8) & 0xFF;
        blue = colorRGB & 0xFF;
    } else { // alpha = 0 means turn the LED off
        red = green = blue = 0;
    }

#ifdef LIGHTS_DBG_ON
    LOG(DEBUG) << __FUNCTION__ << ": colorRGB(" << std::hex << colorRGB <<
               ") red(" << red << ") green(" << green << ") blue(" <<
               blue << ") flashMode(" << (uint32_t) state.flashMode <<
               ") flashOnMS(" << state.flashOnMs << ")";
#endif

    LOG(ERROR) << __FUNCTION__ << ": " << red << ":" << green << ":" << blue;
    mLedBrightness << red << ":" << green << ":" << blue << std::endl;
}

}  // namespace implementation
}  // namespace V2_0
}  // namespace light
}  // namespace hardware
}  // namespace android
