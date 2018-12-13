LOCAL_PATH := $(call my-dir)

ifneq ($(filter SHIFT5me SHIFT6m,$(TARGET_DEVICE)),)

include $(call all-makefiles-under,$(LOCAL_PATH))

include $(CLEAR_VARS)

# Create mount points for NVRAM inside of vendor to make GSIs work
NVCFG_MOUNT_POINT  := $(TARGET_OUT_VENDOR)/etc/nvcfg
NVDATA_MOUNT_POINT := $(TARGET_OUT_VENDOR)/etc/nvdata
PROTECT_F_MOUNT_POINT  := $(TARGET_OUT_VENDOR)/etc/protect_f
PROTECT_S_MOUNT_POINT := $(TARGET_OUT_VENDOR)/etc/protect_s

$(NVCFG_MOUNT_POINT):
	@echo "Creating $(NVCFG_MOUNT_POINT)"
	@mkdir -p $(TARGET_OUT_VENDOR)/etc/nvcfg

$(NVDATA_MOUNT_POINT):
	@echo "Creating $(NVDATA_MOUNT_POINT)"
	@mkdir -p $(TARGET_OUT_VENDOR)/etc/nvdata

$(PROTECT_F_MOUNT_POINT):
	@echo "Creating $(PROTECT_F_MOUNT_POINT)"
	@mkdir -p $(TARGET_OUT_VENDOR)/etc/protect_f

$(PROTECT_S_MOUNT_POINT):
	@echo "Creating $(PROTECT_S_MOUNT_POINT)"
	@mkdir -p $(TARGET_OUT_VENDOR)/etc/protect_s

ALL_DEFAULT_INSTALLED_MODULES += \
    $(NVCFG_MOUNT_POINT) $(NVDATA_MOUNT_POINT) \
    $(PROTECT_F_MOUNT_POINT) $(PROTECT_S_MOUNT_POINT) \

endif
