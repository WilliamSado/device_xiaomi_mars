#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from sm8350-common
$(call inherit-product, device/xiaomi/sm8350-common/common.mk)

# Fingerprint
$(call inherit-product, $(LOCAL_PATH)/platform/board/fingerprint.mk)

# Overlays
$(call inherit-product, $(LOCAL_PATH)/platform/board/overlay.mk)
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/android/overlay-lineage

# PowerShare
$(call inherit-product, $(LOCAL_PATH)/platform/board/powershare.mk)

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Call the proprietary setup
$(call inherit-product, vendor/xiaomi/mars/mars-vendor.mk)
