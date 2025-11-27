#
# Copyright (C) 2019 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include device/stm/stm32mp2/BoardConfigCommon.mk

TARGET_BOARD_PLATFORM := $(SOC_FAMILY)
TARGET_BOOTLOADER_BOARD_NAME := $(BOARD_NAME)
TARGET_BOARD_INFO_FILE := device/stm/stm32mp2/$(BOARD_NAME)/board-info.txt

# =========================================================== #
# Enable dex pre-opt to speed up initial boot                 #
# =========================================================== #
ifeq ($(WITH_DEXPREOPT),)
  WITH_DEXPREOPT := true
  ifneq ($(TARGET_BUILD_VARIANT),user)
    # Retain classes.dex in APK's for non-user builds
    DEX_PREOPT_DEFAULT := nostripping
  endif
endif

# =========================================================== #
# Images and partitions                                       #
# =========================================================== #
TARGET_FS_CONFIG_GEN := device/stm/stm32mp2/$(BOARD_NAME)/config.fs

TARGET_NO_BOOTLOADER := true
TARGET_NO_FSBLIMAGE := false
TARGET_NO_SSBLIMAGE := false

TARGET_NO_KERNEL := false
TARGET_NO_RECOVERY := true
TARGET_NO_RADIOIMAGE := true
TARGET_NO_DTIMAGE := false
TARGET_NO_MISCIMAGE := false
TARGET_NO_SPLASHIMAGE := false
TARGET_NO_TEEFSIMAGE := false
TARGET_NO_FIPIMAGE := false

TARGET_USES_64_BIT_BINDER = true

ifeq ($(BOARD_DISK_HYBRID),false)
BOARD_SUPER_PARTITION_SIZE := ${STM32MP2_SUPER_PART_SIZE}
BOARD_STM32MP2_DYNAMIC_PARTITIONS_SIZE := ${STM32MP2_DYNAMIC_PART_SIZE}
else
BOARD_SUPER_PARTITION_SIZE := ${STM32MP2_HYBRID_SUPER_PART_SIZE}
BOARD_STM32MP2_DYNAMIC_PARTITIONS_SIZE := ${STM32MP2_HYBRID_DYNAMIC_PART_SIZE}
endif

BOARD_SUPER_PARTITION_GROUPS := stm32mp2_dynamic_partitions
BOARD_STM32MP2_DYNAMIC_PARTITIONS_PARTITION_LIST := system system_ext vendor product
# BOARD_SUPER_PARTITION_METADATA_DEVICE := system
# BOARD_SUPER_PARTITION_SYSTEM_DEVICE_SIZE := ${STM32MP2_SYSTEM_PART_SIZE}
# BOARD_SUPER_PARTITION_VENDOR_DEVICE_SIZE := ${STM32MP2_VENDOR_PART_SIZE}
BOARD_BUILD_SUPER_IMAGE_BY_DEFAULT := true
BOARD_SUPER_IMAGE_IN_UPDATE_PACKAGE := true

# enable AVB
BOARD_AVB_ENABLE := true

# system.img
BOARD_SYSTEMIMAGE_JOURNAL_SIZE := 0
BOARD_SYSTEMIMAGE_EXTFS_INODE_COUNT := 4096

# system_ext.img
BOARD_USES_SYSTEM_EXTIMAGE := true
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_SYSTEM_EXT := system_ext

# manage squashfs/sparse format for system image, disable by default for now
TARGET_USERIMAGES_SPARSE_SQUASHFS_DISABLED := true
ifeq ($(TARGET_USERIMAGES_SPARSE_SQUASHFS_DISABLED),false)
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := squashfs
endif

# userdata.img
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
ifeq ($(BOARD_DISK_HYBRID),false)
BOARD_USERDATAIMAGE_PARTITION_SIZE := ${STM32MP2_USERDATA_PART_SIZE}
else
BOARD_USERDATAIMAGE_PARTITION_SIZE := ${STM32MP2_HYBRID_USERDATA_PART_SIZE}
endif
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs

ifeq ($(TARGET_USERIMAGES_SPARSE_EXT_DISABLED),)
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false
endif

# teefs.img
BOARD_TEEFSIMAGE_PARTITION_SIZE := ${STM32MP2_TEEFS_PART_SIZE}

# product.img
BOARD_USES_PRODUCTIMAGE := true
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_PRODUCT := product

# vendor.img
BOARD_USES_VENDORIMAGE := true
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
ifeq ($(TARGET_USERIMAGES_SPARSE_SQUASHFS_DISABLED),false)
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := squashfs
endif
TARGET_COPY_OUT_VENDOR := vendor

# metadata.img
BOARD_USES_METADATA_PARTITION := true
BOARD_METADATAIMAGE_PARTITION_SIZE := ${STM32MP2_METADATA_PART_SIZE}

# Install modules
KERNEL_MODULE_DIR := device/stm/stm32mp2-kernel/prebuilt/modules
KERNEL_MODULES := $(wildcard $(KERNEL_MODULE_DIR)/*.ko)

# put all modules in /vendor/lib/modules
BOARD_VENDOR_KERNEL_MODULES := $(KERNEL_MODULES)

# Allow LZ4 compression
BOARD_RAMDISK_USE_LZ4 := true

# boot.img
BOARD_BOOTIMAGE_PARTITION_SIZE := ${STM32MP2_BOOT_PART_SIZE}
BOARD_USES_GENERIC_KERNEL_IMAGE := true

# vendor_boot.img (48MB for Kernel, 8MB for DT, 16MB for RAMDISK)
BOARD_KERNEL_BASE        := 0x88000000
BOARD_KERNEL_PAGESIZE    := 4096
BOARD_DTB_OFFSET         := 0x03000000
BOARD_RAMDISK_OFFSET     := 0x03800000

BOARD_BOOT_HEADER_VERSION    := 3
BOARD_INCLUDE_DTB_IN_BOOTIMG := true

BOARD_MKBOOTIMG_ARGS := --ramdisk_offset $(BOARD_RAMDISK_OFFSET) --dtb_offset $(BOARD_DTB_OFFSET) --header_version $(BOARD_BOOT_HEADER_VERSION)

BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE := ${STM32MP2_VENDOR_BOOT_PART_SIZE}

# Specify BOOT_KERNEL_MODULES
#
# modules for first stage in vendor_boot.img, the remainder goes to vendor.img
BOOT_KERNEL_MODULES := \
    hwmon.ko \
    mr75203.ko \
    scmi-hwmon.ko \
    arm_scpi.ko \
    scpi-hwmon.ko \
    scpi-cpufreq.ko \
    clk-scpi.ko \
    scpi_pm_domain.ko \
    cpufreq-dt.ko \
    spi-stm32.ko \
    spidev.ko \
    stm32-crc32.ko \
    stm32-cryp.ko \
    stm32-hash.ko \
    i2c-demux-pinctrl.ko \
    mdio-mux.ko \
    stm32_ddr_pmu.ko \
    ofpart.ko \
    ohci-pci.ko \
    optee-rng.ko \
    virtio_blk.ko \
    zsmalloc.ko \
    zram.ko \
    rtc-stm32.ko

BOOT_KERNEL_MODULES_FILTER := $(foreach m,$(BOOT_KERNEL_MODULES),%/$(m))
BOARD_VENDOR_RAMDISK_KERNEL_MODULES := $(filter $(BOOT_KERNEL_MODULES_FILTER),$(KERNEL_MODULES))

# Use BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD to override
# the content of the generated modules.load file
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD := $(BOOT_KERNEL_MODULES)

# dtbo.img
BOARD_DTBOIMG_PARTITION_SIZE := ${STM32MP2_DTBO_PART_SIZE}

# Enable A/B partitions mechanism for the update engine
AB_OTA_UPDATER := true

AB_OTA_PARTITIONS += \
    boot \
    vendor_boot \
    dtbo \
    system \
    system_ext \
    vendor \
    product

ifneq ($(BOARD_AVB_ENABLE),false)
AB_OTA_PARTITIONS += vbmeta
endif

# =========================================================== #
# Kernel command line                                         #
# =========================================================== #
BOARD_KERNEL_CMDLINE := androidboot.console=ttySTM0 serdev_ttyport.pdev_tty_port=ttyXXX consoleblank=0
BOARD_KERNEL_CMDLINE += root=/dev/ram rw rootfstype=ext4 rootwait
BOARD_KERNEL_CMDLINE += init=/init firmware_class.path=/vendor/firmware blk-crypto-fallback.num_keyslots=1
BOARD_KERNEL_CMDLINE += androidboot.hardware=stm androidboot.fake_battery=1
# TODO : add it in U-Boot instead (dynamic)
BOARD_KERNEL_CMDLINE += androidboot.dtbo_idx=0

ifeq ($(BOARD_DISK_TYPE),emmc)
ifeq ($(BOARD_DISK_HYBRID),true)
BOARD_KERNEL_CMDLINE += androidboot.boot_devices=soc@0/42080000.rifsc/48230000.mmc,soc@0/42080000.rifsc/48220000.mmc
else
BOARD_KERNEL_CMDLINE += androidboot.boot_devices=soc@0/42080000.rifsc/48230000.mmc
endif
else
BOARD_KERNEL_CMDLINE += androidboot.boot_devices=soc@0/42080000.rifsc/48220000.mmc
endif

ifneq ($(TARGET_BUILD_VARIANT),user)

ifeq (,$(filter st-demo, $(BOARD_OPTION)))

BOARD_KERNEL_CMDLINE += no_console_suspend
BOARD_KERNEL_CMDLINE += loglevel=8
BOARD_KERNEL_CMDLINE += printk.devkmsg=on
BOARD_KERNEL_CMDLINE += console=ttySTM0,115200 earlycon
endif

BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive

# Enable graphic trace (drm)
# BOARD_KERNEL_CMDLINE += drm.debug=0x3f

# Enable dynamic debug (for file) on boot (change <path_to_file> by required kernel file)
# BOARD_KERNEL_CMDLINE += dyndbg=\"file <path_to_file> +p\"

# Enable atrace on boot for task scheduling
# BOARD_KERNEL_CMDLINE +=trace_buf_size=64M
# BOARD_KERNEL_CMDLINE +=trace_event=sched_process_exit,sched_switch,sched_process_free,task_newtask,task_rename

# Enable atrace on boot for I/O analysis
# BOARD_KERNEL_CMDLINE +=trace_buf_size=64M
# BOARD_KERNEL_CMDLINE +=trace_event=block,ext4

# Enable early print in console on boot
# BOARD_KERNEL_CMDLINE += earlyprintk

endif

# =========================================================== #
# Sub-systems configuration                                   #
# =========================================================== #

# bluetooth configuration
BOARD_HAVE_BLUETOOTH := false

# wi-fi configuration
ifeq ($(BOARD_WLAN_INTERFACE), wlan0)
BOARD_WLAN_DEVICE := stm
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
WIFI_HAL_INTERFACE_COMBINATIONS := {{{STA}, 1}, {{AP}, 1}}
#WIFI_DRIVER_FW_PATH_AP := "/vendor/firmware/xxx.fw"
#WIFI_DRIVER_FW_PATH_STA := "/vendor/firmware/xxx.fw"
#WIFI_DRIVER_FW_PATH_P2P := "/vendor/firmware/xxx.fw"
else
error BOARD_WLAN_INTERFACE wrongly defined
endif

# graphics configuration
BOARD_GPU_DRIVERS := vivante

TARGET_USE_PRIVATE_LIBDRM := false
TARGET_USES_HWC2 := true
BOARD_USES_DRM_HWCOMPOSER_STM := true
BOARD_DRM_HWCOMPOSER_BUFFER_IMPORTER := stm32mpu

# =========================================================== #
# General configuration                                       #
# =========================================================== #
TARGET_SCREEN_DENSITY := 240

# recovery configuration
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true

TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_RECOVERY_UI_MARGIN_HEIGHT := 165
TARGET_RECOVERY_UI_LIB := librecovery_ui_stm
TARGET_RECOVERY_FSTAB := device/stm/stm32mp2/$(BOARD_NAME)/fstab_$(BOARD_DISK_TYPE).stm
TARGET_RECOVERY_WIPE := device/stm/stm32mp2/$(BOARD_NAME)/recovery.wipe

# vendor manifest and compatibility matrix
DEVICE_MANIFEST_FILE := device/stm/stm32mp2/$(BOARD_NAME)/manifest.xml
ifeq ($(BOARD_SECURITY),optee)
DEVICE_MANIFEST_FILE += device/stm/stm32mp2/$(BOARD_NAME)/manifest_security.xml
endif

DEVICE_MATRIX_FILE := device/stm/stm32mp2/$(BOARD_NAME)/compatibility_matrix.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := device/stm/stm32mp2/$(BOARD_NAME)/framework_compatibility_matrix.xml

# sepolicy
BOARD_VENDOR_SEPOLICY_DIRS += device/stm/stm32mp2/$(BOARD_NAME)/sepolicy

# properties
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true

# vndk
BOARD_VNDK_VERSION := current

#SDK
ifneq ($(filter sdk win_sdk sdk_addon,$(MAKECMDGOALS)),)
BUILD_BROKEN_DUP_RULES := true
endif
