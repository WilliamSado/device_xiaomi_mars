
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

ANDROID_ROOT="${MY_DIR}/../../.."

export TARGET_ENABLE_CHECKELF=true

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in
        vendor/lib64/libwvhidl.so|vendor/lib64/mediadrm/libwvdrmengine.so)
            [ "$2" = "" ] && return 0
            grep -q "libcrypto_shim.so" "${2}" || "${PATCHELF}" --add-needed "libcrypto_shim.so" "${2}"
            ;;
        vendor/etc/media_lahaina/video_system_specs.json)
            sed -i "/max_retry_alloc_output_timeout/ s/10000/0/" "${2}"
            ;;
        vendor/lib64/android.hardware.secure_element@1.0-impl.so)
            "${PATCHELF}" --remove-needed "android.hidl.base@1.0.so" "${2}"
            ;;
        vendor/lib64/vendor.xiaomi.hardware.cameraperf@1.0-impl.so)
            hexdump -ve '1/1 "%.2X"' "${2}" | sed "s/7C000094881640F9/1F2003D5881640F9/g" | xxd -r -p > "${EXTRACT_TMP_DIR}/${1##*/}"
            mv "${EXTRACT_TMP_DIR}/${1##*/}" "${2}"
            ;;
        vendor/lib64/vendor.qti.hardware.camera.postproc@1.0-service-impl.so)
            hexdump -ve '1/1 "%.2X"' "${2}" | sed "s/8D0A0094AE1640F9/1F2003D5AE1640F9/g" | xxd -r -p > "${EXTRACT_TMP_DIR}/${1##*/}"
            mv "${EXTRACT_TMP_DIR}/${1##*/}" "${2}"
            ;;
        vendor/lib64/hw/camera.xiaomi.so)
            hexdump -ve '1/1 "%.2X"' "${2}" | sed "s/5E070094881640F9/1F2003D5881640F9/g; s/AA060094881640F9/1F2003D5881640F9/g" | xxd -r -p > "${EXTRACT_TMP_DIR}/${1##*/}"
            mv "${EXTRACT_TMP_DIR}/${1##*/}" "${2}"
            ;;
        vendor/etc/camera/pureShot_parameter.xml \
        |vendor/etc/camera/pureView_parameter.xml)
            sed -i 's/=\([0-9]\+\)>/="\1">/g' "${2}"
            ;;
        vendor/lib64/hw/camera.qcom.so)
            sed -i "s/\x73\x74\x5F\x6C\x69\x63\x65\x6E\x73\x65\x2E\x6C\x69\x63/\x63\x61\x6D\x65\x72\x61\x5F\x63\x6E\x66\x2E\x74\x78\x74/g" "${2}"
            ;;
        vendor/etc/camera/star_motiontuning.xml|vendor/etc/camera/mars_motiontuning.xml)
            sed -i 's/xml=version/xml\ version/g' "${2}"
            ;;
        vendor/lib64/libwa_sat.so)
            sed -i 's/\/system\/lib64\([^\/]\)/\/vendor\/lib64\1/g' "${2}"
            ;;
    esac
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"

"${MY_DIR}/setup-makefiles.sh"
