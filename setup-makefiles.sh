
#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=mars
VENDOR=xiaomi

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

export TARGET_ENABLE_CHECKELF=true

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

function vendor_imports() {
    cat <<EOF >>"$1"
        "hardware/xiaomi",
        "hardware/qcom/display",
        "hardware/qcom/display/gralloc",
        "hardware/qcom/display/libdebug",
        "vendor/qcom/common/vendor/adreno-r",
        "vendor/qcom/common/vendor/display/5.4",
        "vendor/qcom/common/vendor/gps-legacy",
        "vendor/qcom/common/vendor/keymaster",
        "vendor/qcom/common/vendor/media-5.4",
        "vendor/qcom/common/vendor/wlan-legacy",
EOF
}

function lib_to_package_fixup_vendor_variants() {
    if [ "$2" != "vendor" ]; then
        return 1
    fi

    case "$1" in
        com.qualcomm.qti.dpm.api@1.0 | \
            com.qualcomm.qti.imscmservice* | \
            com.qualcomm.qti.uceservice* | \
            libmmosal | \
            libmegface | \
            libqcbor | \
            vendor.qti.data.* | \
            vendor.qti.diaghal@1.0 | \
            vendor.qti.hardware.data.* | \
            vendor.qti.hardware.embmssl* | \
            vendor.qti.hardware.mwqemadapter@1.0 | \
            vendor.qti.hardware.radio.* | \
            vendor.qti.hardware.slmadapter@1.0 | \
            vendor.qti.hardware.wifidisplaysession@1.0 | \
            vendor.qti.imsrtpservice@3.0 | \
            vendor.qti.ims.* | \
            vendor.qti.latency*)
            echo "$1-vendor"
            ;;

        audio.primary.lahaina | \
            libsndmonitor | \
            libcomprcapture | \
            libhdmiedid | \
            libhfp | \
            libexthwplugin | \
            liba2dpoffload | \
            libbatterylistener | \
            libhdmiedid | \
            libhdmipassthru | \
            libhfp | \
            libssrec | \
            libspkrprot)
            echo "$1_sm8350"
            ;;

        libOmxCore | \
            libwfdaac_vendor | \
            libwpa_client) ;;
        *)
            return 1
            ;;
    esac
}
function lib_to_package_fixup() {
    lib_to_package_fixup_clang_rt_ubsan_standalone "$1" ||
        lib_to_package_fixup_proto_3_9_1 "$1" ||
        lib_to_package_fixup_vendor_variants "$@"
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}"

# Warning headers and guards
write_headers

write_makefiles "${MY_DIR}/proprietary-files.txt"

# Finish
write_footers