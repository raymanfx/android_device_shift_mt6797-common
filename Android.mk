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

# Symlink old mount points for blob compatibility
NVCFG_SYMLINK := $(TARGET_ROOT_OUT)/nvcfg
$(NVCFG_SYMLINK): $(LOCAL_INSTALLED_MODULE)
	@echo "Creating NVCFG symlink: $(TARGET_ROOT_OUT)/nvcfg -> /vendor/etc/nvcfg"
	$(hide) ln -sf /vendor/etc/nvcfg $(TARGET_ROOT_OUT)/nvcfg

NVDATA_SYMLINK := $(TARGET_ROOT_OUT)/nvdata
$(NVDATA_SYMLINK): $(LOCAL_INSTALLED_MODULE)
	@echo "Creating NVDATA symlink: $(TARGET_ROOT_OUT)/nvdata -> /vendor/etc/nvdata"
	$(hide) ln -sf /vendor/etc/nvdata $(TARGET_ROOT_OUT)/nvdata

PROTECT_F_SYMLINK := $(TARGET_ROOT_OUT)/protect_f
$(PROTECT_F_SYMLINK): $(LOCAL_INSTALLED_MODULE)
	@echo "Creating PROTECT_F symlink: $(TARGET_ROOT_OUT)/protect_f -> /vendor/etc/protect_f"
	$(hide) ln -sf /vendor/etc/protect_f $(TARGET_ROOT_OUT)/protect_f

PROTECT_S_SYMLINK := $(TARGET_ROOT_OUT)/protect_s
$(PROTECT_S_SYMLINK): $(LOCAL_INSTALLED_MODULE)
	@echo "Creating PROTECT_S symlink: $(TARGET_ROOT_OUT)/protect_s -> /vendor/etc/protect_s"
	$(hide) ln -sf /vendor/etc/protect_s $(TARGET_ROOT_OUT)/protect_s

ALL_DEFAULT_INSTALLED_MODULES += \
    $(NVCFG_SYMLINK) $(NVDATA_SYMLINK) \
    $(PROTECT_F_SYMLINK) $(PROTECT_S_SYMLINK) \

endif
