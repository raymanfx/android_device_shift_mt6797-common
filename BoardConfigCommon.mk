# Use the non-open-source part, if present
-include vendor/mediatek/k97v1_64/BoardConfigVendor.mk

# Use the 6797 common part
include device/mediatek/mt6797/BoardConfig.mk

# Configure partition size
-include $(MTK_PTGEN_OUT)/partition_size.mk

BOARD_FLASH_BLOCK_SIZE := 4096

MTK_INTERNAL_CDEFS := $(foreach t,$(AUTO_ADD_GLOBAL_DEFINE_BY_NAME),$(if $(filter-out no NO none NONE false FALSE,$($(t))),-D$(t)))
MTK_INTERNAL_CDEFS += $(foreach t,$(AUTO_ADD_GLOBAL_DEFINE_BY_VALUE),$(if $(filter-out no NO none NONE false FALSE,$($(t))),$(foreach v,$(shell echo $($(t)) | tr '[a-z]' '[A-Z]'),-D$(v))))
MTK_INTERNAL_CDEFS += $(foreach t,$(AUTO_ADD_GLOBAL_DEFINE_BY_NAME_VALUE),$(if $(filter-out no NO none NONE false FALSE,$($(t))),-D$(t)=\"$(strip $($(t)))\"))

MTK_GLOBAL_CFLAGS += $(MTK_INTERNAL_CDEFS)

# Camera
MTK_CAM_DEFAULT_ZSD_ON_SUPPORT := yes

# Recovery
TARGET_RECOVERY_UI_MARGIN_HEIGHT := 32
TARGET_RECOVERY_UI_MARGIN_WIDTH  := 32

# SEPolicy - include common MTK sepolicy
include device/shift/sepolicy/mtk/sepolicy.mk
