#
# Copyright (C) 2023 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/xiaomi/mars

# Inherit from sm8350-common
include device/xiaomi/sm8350-common/BoardConfigCommon.mk

# Board
TARGET_BOOTLOADER_BOARD_NAME := mars

# Display
TARGET_SCREEN_DENSITY := 560

# Init
TARGET_INIT_VENDOR_LIB := //$(DEVICE_PATH):libinit_mars
TARGET_RECOVERY_DEVICE_MODULES := libinit_mars

# Kernel
KERNEL_FRAGMENT_CONFIG := vendor/star_QGKI.config

# Kernel modules
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_MODULES_OUT)/cs35l41_dlkm.ko \
    $(KERNEL_MODULES_OUT)/fts_touch_spi.ko \
    $(KERNEL_MODULES_OUT)/goodix_fod.ko \
    $(KERNEL_MODULES_OUT)/xiaomi_touch.ko

# OTA assert
TARGET_OTA_ASSERT_DEVICE := mars,star

# Partitions
BOARD_DTBOIMG_PARTITION_SIZE := 25165824
BOARD_USERDATAIMAGE_PARTITION_SIZE := 114001162240

# Properties
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

# Recovery
TARGET_RECOVERY_UI_MARGIN_HEIGHT := 165

# Include proprietary files
include vendor/xiaomi/mars/BoardConfigVendor.mk
