#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from sm8350-common
include device/xiaomi/sm8350-common/BoardConfigCommon.mk

DEVICE_PATH := device/xiaomi/mars
BOARD_CONFIG_PATH := $(DEVICE_PATH)/platform/board

# Board
include $(BOARD_CONFIG_PATH)/board.mk

# Kernel
include $(BOARD_CONFIG_PATH)/kernel.mk

# Partitions
include $(BOARD_CONFIG_PATH)/partitions.mk

# Properties
include $(BOARD_CONFIG_PATH)/properties.mk

# Include proprietary files
include vendor/xiaomi/mars/BoardConfigVendor.mk
