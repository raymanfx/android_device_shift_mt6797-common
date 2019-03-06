LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_PROVIDES_LIBLIGHT),true)

include $(CLEAR_VARS)

LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_MODULE := android.hardware.light@2.0-service-shift
LOCAL_INIT_RC := android.hardware.light@2.0-service-shift.rc
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_OWNER := SHIFT
LOCAL_SRC_FILES := \
    Light.cpp \
    service.cpp \

LOCAL_SHARED_LIBRARIES := \
    libbase \
    libcutils \
    libhardware \
    liblog \
    libutils \

LOCAL_SHARED_LIBRARIES += \
    android.hardware.light@2.0 \
    libhwbinder \
    libhidlbase \
    libhidltransport \

include $(BUILD_EXECUTABLE)

endif # TARGET_PROVIDES_LIBLIGHT
