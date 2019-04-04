# do not restrict vendor files
PRODUCT_RESTRICT_VENDOR_FILES := false

# overlay has priorities. high <-> low.
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

ifneq ($(findstring lineage, $(TARGET_PRODUCT)),)
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay-lineage
endif

# AAPT
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := 420dpi
PRODUCT_AAPT_PREBUILT_DPI := xxhdpi xhdpi hdpi

# Boot animation
TARGET_SCREEN_HEIGHT := 1920
TARGET_SCREEN_WIDTH  := 1080

# A/B
AB_OTA_UPDATER := true

AB_OTA_PARTITIONS += \
    boot \
    system

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

PRODUCT_PACKAGES += \
    otapreopt_script

# Boot control
PRODUCT_PACKAGES_DEBUG += \
    bootctl

PRODUCT_STATIC_BOOT_CONTROL_HAL := \
    bootctrl.mt6797

# Update engine
PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_engine_client

# Init
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,${LOCAL_PATH}/init/vendor,$(TARGET_COPY_OUT_VENDOR))

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml \

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.faketouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.faketouch.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \

####################################################################################################################################################################################

# Audio
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio/audio_policy.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy.conf:mtk \

PRODUCT_COPY_FILES += \
    frameworks/av/media/libeffects/data/audio_effects.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.conf \


PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio/srs_processing.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/srs_processing.cfg:mtk \

PRODUCT_PROPERTY_OVERRIDES += \
    ro.camera.sound.forced=0 \
    ro.audio.silent=0 \

# Display
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=420 \
    debug.sf.enable_hwc_vds=1 \

# Keyboard layout
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/keylayout/mtk-kpd.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/mtk-kpd.kl:mtk \

# Light HAL
PRODUCT_PACKAGES += \
    android.hardware.light@2.0-service-shift

# Logs (set buffer to 1M on userdebug and eng builds)
ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
PRODUCT_PROPERTY_OVERRIDES += ro.logd.size=1M
endif

# Media
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles.xml

# Performance
PRODUCT_PROPERTY_OVERRIDES += \
    ro.mtk_perf_simple_start_win=1 \
    ro.mtk_perf_fast_start_win=1 \
    ro.mtk_perf_response_time=1 \

# Properties
PRODUCT_PROPERTY_OVERRIDES += \
    persist.service.acm.enable=0 \
    qemu.hw.mainkeys=0 \
    ro.mediatek.chip_ver=S01 \
    ro.mediatek.platform=MT6797 \
    ro.kernel.zio=38,108,105,16 \
    sys.ipo.disable=1 \
    sys.ipo.pwrdncap=2 \

# RIL
SIM_COUNT := 2

PRODUCT_PROPERTY_OVERRIDES += \
    rild.libpath=mtk-ril.so \
    rild.libargs=-d/dev/ttyC0 \
    ro.telephony.sim.count=2 \
    persist.radio.default.sim=0 \

# SAR
#PRODUCT_PACKAGES += MTKSARTestProgram
#PRODUCT_PACKAGES += SARSETTINGS

# Sensors
PRODUCT_PACKAGES += pscali

# USB
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sys.usb.bicr=no \
    ro.sys.usb.charging.only=yes \
    ro.sys.usb.mtp.whql.enable=0 \
    ro.sys.usb.storage.type=mtp \

# WiFi
PRODUCT_PROPERTY_OVERRIDES += \
    wifi.interface=wlan0 \
    ro.mediatek.wlan.wsc=1 \
    ro.mediatek.wlan.p2p=1 \
    mediatek.wlan.ctia=0 \
    wifi.tethering.interface=ap0 \
    wifi.direct.interface=p2p0 \

# Remove unwanted packages
PRODUCT_PACKAGES += \
    RemovePackages
