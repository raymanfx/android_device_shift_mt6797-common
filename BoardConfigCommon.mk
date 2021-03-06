COMMON_PATH := device/shift/mt6797-common

# Platform
TARGET_BOARD_PLATFORM := mt6797
TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a53
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53

# Kernel
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_KERNEL_SOURCE := kernel/shift/mt6797

# Boot image
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb
BOARD_KERNEL_BASE := 0x40078000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_CMDLINE = bootopt=64S3,32N2,64N2
BOARD_MKBOOTIMG_ARGS := --kernel_offset 0x00008000 --ramdisk_offset 0x04f88000 --second_offset=0x00e88000 --tags_offset 0x03f88000
KERNEL_TOOLCHAIN := $(ANDROID_BUILD_TOP)/prebuilts/gcc/$(HOST_OS)-x86/aarch64/aarch64-linux-gnu-6.3.1/bin
TARGET_KERNEL_CROSS_COMPILE_PREFIX := aarch64-linux-gnu-
TARGET_NEEDS_DTBOIMAGE := true
TARGET_DTBO_IMAGE_NAME := odmdtbo
TARGET_DTBO_IMAGE_TARGET := odmdtboimage
TARGET_DTBO_IMAGE_PATH := $(PRODUCT_OUT)/dtbo/arch/$(TARGET_KERNEL_ARCH)/boot/dts/$(TARGET_DTBO_IMAGE_NAME).img

# Partitions
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
BOARD_BOOTIMAGE_PARTITION_SIZE := 16777216
BOARD_DTBOIMG_PARTITION_SIZE := 536870912
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2684354560
BOARD_USERDATAIMAGE_PARTITION_SIZE := 54374940160
BOARD_FLASH_BLOCK_SIZE := 4096

# Filesystem
TARGET_USERIMAGES_USE_EXT4 := true

# Camera
MTK_CAM_DEFAULT_ZSD_ON_SUPPORT := yes

# exFAT / sdfat
TARGET_EXFAT_DRIVER := sdfat

# Lights
TARGET_PROVIDES_LIBLIGHT := true

# Binder
TARGET_USES_64_BIT_BINDER := true

# Graphics
TARGET_USES_HWC2 := true
TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

# Panel vsync offsets
VSYNC_EVENT_PHASE_OFFSET_NS := 8300000
SF_VSYNC_EVENT_PHASE_OFFSET_NS := 8300000
PRESENT_TIME_OFFSET_FROM_VSYNC_NS := 0

# Recovery
BOARD_USES_RECOVERY_AS_BOOT := true
TARGET_NO_RECOVERY := true
TARGET_RECOVERY_UI_BLANK_UNBLANK_ON_INIT := true
TARGET_RECOVERY_UI_MARGIN_HEIGHT := 32
TARGET_RECOVERY_UI_MARGIN_WIDTH  := 32
ifeq ($(RECOVERY_VARIANT),twrp)
    TARGET_RECOVERY_FSTAB := $(COMMON_PATH)/twrp/twrp.fstab
    TW_EXCLUDE_DEFAULT_USB_INIT := true
    TW_EXCLUDE_TWRPAPP := true
    TW_USE_TOOLBOX := true
else
    TARGET_RECOVERY_FSTAB := $(COMMON_PATH)/init/root/fstab.mt6797
endif
LZMA_RAMDISK_TARGETS := recovery

# Seccomp filters
BOARD_SECCOMP_POLICY += $(COMMON_PATH)/seccomp

# SELinux
BOARD_SEPOLICY_VERS := $(PLATFORM_SDK_VERSION).0
BOARD_PLAT_PRIVATE_SEPOLICY_DIR += $(COMMON_PATH)/sepolicy/private

# Treble
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true
BOARD_VNDK_RUNTIME_DISABLE := true
BOARD_VNDK_VERSION := current

# Vendor
TARGET_COPY_OUT_VENDOR := vendor

# HIDL Manifest
#DEVICE_MANIFEST_FILE += device/shift/mt6797-common/manifest.xml

# Shims
TARGET_LD_SHIM_LIBS := \
    /system/lib/vndk-26/libstagefright_omx.so|/system/lib/libstagefright_omx_shim.so \
    /system/lib64/vndk-26/libstagefright_omx.so|/system/lib64/libstagefright_omx_shim.so

# Inherit from the proprietary version
-include vendor/shift/mt6797-common/BoardConfigVendor.mk
