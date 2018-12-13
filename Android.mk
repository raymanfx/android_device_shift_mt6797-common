LOCAL_PATH := $(call my-dir)

ifneq ($(filter SHIFT5me SHIFT6m,$(TARGET_DEVICE)),)

include $(call all-makefiles-under,$(LOCAL_PATH))

endif
