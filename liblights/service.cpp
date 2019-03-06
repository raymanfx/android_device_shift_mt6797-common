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

#define LOG_TAG "LightService"

#include <android-base/logging.h>
#include <hidl/HidlTransportSupport.h>
#include <utils/Errors.h>

#include "Light.h"

// libhwbinder:
using android::hardware::configureRpcThreadpool;
using android::hardware::joinRpcThreadpool;

// Generated HIDL files
using android::hardware::light::V2_0::ILight;
using android::hardware::light::V2_0::implementation::Light;

const static std::string kLcdBacklightPath = "/sys/class/leds/lcd-backlight/brightness";
const static std::string kLedBrightnessPath = "/sys/devices/soc/11007000.i2c/i2c-0/0-0030/ktd2037/brightness";
const static std::string kLedFlashModePath = "/sys/devices/soc/11007000.i2c/i2c-0/0-0030/ktd2037/flash_mode";
const static std::string kLedFlashPeriodPath = "/sys/devices/soc/11007000.i2c/i2c-0/0-0030/ktd2037/flash_period";

int main() {
    int ret = 0;
    android::sp<ILight> service;
    android::status_t status = android::OK;
    std::ofstream lcdBacklight, ledBrightness, ledFlashMode, ledFlashPeriod;

    lcdBacklight.open(kLcdBacklightPath);
    if (!lcdBacklight) {
        LOG(ERROR) << "Failed to open " << kLcdBacklightPath << ", error=" << errno
                   << " (" << strerror(errno) << ")";
        ret = -errno;
        goto bl_error;
    }

    ledBrightness.open(kLedBrightnessPath);
    if (!ledBrightness) {
        LOG(ERROR) << "Failed to open " << kLedBrightnessPath << ", error=" << errno
                   << " (" << strerror(errno) << ")";
        ret = -errno;
        goto br_error;
    }

    ledFlashMode.open(kLedFlashModePath);
    if (!ledFlashMode) {
        LOG(ERROR) << "Failed to open " << kLedFlashModePath << ", error=" << errno
                   << " (" << strerror(errno) << ")";
        ret = -errno;
        goto flmode_error;
    }

    ledFlashPeriod.open(kLedFlashPeriodPath);
    if (!ledFlashPeriod) {
        LOG(ERROR) << "Failed to open " << kLedFlashPeriodPath << ", error=" << errno
                   << " (" << strerror(errno) << ")";
        ret = -errno;
        goto flper_error;
    }

    service = new Light(
            std::move(lcdBacklight), std::move(ledBrightness),
            std::move(ledFlashMode), std::move(ledFlashPeriod));

    configureRpcThreadpool(1, true);

    status = service->registerAsService();

    if (status != android::OK) {
        LOG(ERROR) << "Cannot register Light HAL service";
        ret = 1;
        goto reg_error;
    }

    LOG(INFO) << "Light HAL Ready.";
    joinRpcThreadpool();
    // Under normal cases, execution will not reach this line.
    LOG(ERROR) << "Light HAL failed to join thread pool.";
    ret = 1;

reg_error:
    ledFlashPeriod.close();

flper_error:
    ledFlashMode.close();

flmode_error:
    ledBrightness.close();

br_error:
    lcdBacklight.close();

bl_error:
    return -errno;
}
