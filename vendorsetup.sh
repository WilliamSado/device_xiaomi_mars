echo 'Starting to clone stuffs needed to build for Mars'

# Device
echo 'Cloning Device tree'
rm -rf device/xiaomi/mars
git clone https://github.com/WilliamSado/device_xiaomi_mars -b udc-elixir device/xiaomi/mars

# Kernel
echo 'Cloning Kernel tree'
rm -rf kernel/xiaomi/mars
git clone --depth=1 https://github.com/WilliamSado/kernel_xiaomi_mars -b udc-elixir  kernel/xiaomi/mars

# Vendor
echo 'Cloning Vendor tree'
rm -rf vendor/xiaomi/mars
git clone https://github.com/WilliamSado/vendor_xiaomi_mars -b udc-elixir vendor/xiaomi/mars

# Firmware
echo 'Cloning Firmware'
rm -rf vendor/xiaomi/mars-firmware
git clone --depth=1 https://gitlab.com/William_sado/vendor_xiaomi_mars-firmware -b fourteen vendor/xiaomi/mars-firmware

# Xiaomi
echo 'Cloning Hardware xiaomi'
rm -rf hardware/xiaomi
git clone --depth=1 https://github.com/LineageOS/android_hardware_xiaomi -b lineage-20 hardware/xiaomi

# Gcam
echo 'Cloning GCam MGC'
rm -rf vendor/MGC
git clone --depth=1  https://gitlab.com/William_sado/vendor_googlecamera -b bsg vendor/MGC

# Hardware-Display
rm -rf hardware/qcom-caf/sm8350/display
git clone https://github.com/Evolution-X/hardware_qcom-caf_sm8350_display -b udc hardware/qcom-caf/sm8350/display

echo 'delete vendorsetup.sh from device tree once this is done'