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

include device/stm/stm32mp1/BoardConfigCommon.mk

TARGET_BOARD_PLATFORM := $(SOC_FAMILY)
TARGET_BOOTLOADER_BOARD_NAME := $(BOARD_NAME)
TARGET_BOARD_INFO_FILE := device/stm/stm32mp1/$(BOARD_NAME)/board-info.txt

# =========================================================== #
# Enable dex pre-opt to speed up initial boot                 #
# =========================================================== #
ifeq ($(HOST_OS),linux)
  ifeq ($(WITH_DEXPREOPT),)
    WITH_DEXPREOPT := true
    WITH_DEXPREOPT_PIC := true
    ifneq ($(TARGET_BUILD_VARIANT),user)
      # Retain classes.dex in APK's for non-user builds
      DEX_PREOPT_DEFAULT := nostripping
    endif
  endif
endif

# =========================================================== #
# Images and partitions                                       #
# =========================================================== #

TARGET_NO_BOOTLOADER := true
TARGET_NO_FSBLIMAGE := false
TARGET_NO_SSBLIMAGE := false

TARGET_NO_KERNEL := false
TARGET_NO_RECOVERY := true
TARGET_NO_RADIOIMAGE := true
TARGET_NO_DTIMAGE := false
TARGET_NO_MISCIMAGE := false
TARGET_NO_SPLASHIMAGE := false

# temporary for TEE build (to be removed)
BUILD_BROKEN_PHONY_TARGETS := true

# BOARD_USES_RECOVERY_AS_BOOT := true
TARGET_USES_64_BIT_BINDER = true

BOARD_SUPER_PARTITION_SIZE := ${STM32MP1_SUPER_PART_SIZE}
BOARD_SUPER_PARTITION_GROUPS := stm32mp1_dynamic_partitions
BOARD_STM32MP1_DYNAMIC_PARTITIONS_PARTITION_LIST := system vendor product
BOARD_STM32MP1_DYNAMIC_PARTITIONS_SIZE := ${STM32MP1_DYNAMIC_PART_SIZE}
# BOARD_SUPER_PARTITION_METADATA_DEVICE := system
# BOARD_SUPER_PARTITION_SYSTEM_DEVICE_SIZE := ${STM32MP1_SYSTEM_PART_SIZE}
# BOARD_SUPER_PARTITION_VENDOR_DEVICE_SIZE := ${STM32MP1_VENDOR_PART_SIZE}
BOARD_BUILD_SUPER_IMAGE_BY_DEFAULT := true
BOARD_SUPER_IMAGE_IN_UPDATE_PACKAGE := true

TARGET_RECOVERY_WIPE := device/stm/stm32mp1/$(BOARD_NAME)/recovery.wipe
TARGET_RECOVERY_FSTAB := device/stm/stm32mp1/$(BOARD_NAME)/fstab_$(BOARD_DISK_TYPE).stm

# enable AVB
# BOARD_AVB_ENABLE := true
# BOARD_BOOTIMAGE_PARTITION_SIZE := ${STM32MP1_BOOT_PART_SIZE}

# system.img
# BOARD_SYSTEMIMAGE_PARTITION_SIZE := ${STM32MP1_SYSTEM_PART_SIZE}
BOARD_SYSTEMIMAGE_JOURNAL_SIZE := 0
BOARD_SYSTEMIMAGE_EXTFS_INODE_COUNT := 4096

# manage squashfs/sparse format for system image, disable by default for now
TARGET_USERIMAGES_SPARSE_SQUASHFS_DISABLED := true
ifeq ($(TARGET_USERIMAGES_SPARSE_SQUASHFS_DISABLED),false)
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := squashfs
endif

# userdata.img
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_USERDATAIMAGE_PARTITION_SIZE := ${STM32MP1_USERDATA_PART_SIZE}
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs

ifeq ($(TARGET_USERIMAGES_SPARSE_EXT_DISABLED),)
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false
endif

# product.img
BOARD_USES_PRODUCTIMAGE := true
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_PRODUCT := product

# vendor.img
BOARD_USES_VENDORIMAGE := true
# BOARD_VENDORIMAGE_PARTITION_SIZE := ${STM32MP1_VENDOR_PART_SIZE}
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
ifeq ($(TARGET_USERIMAGES_SPARSE_SQUASHFS_DISABLED),false)
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := squashfs
endif
TARGET_COPY_OUT_VENDOR := vendor

# boot.img
BOARD_KERNEL_BASE        := 0xC0008000
BOARD_KERNEL_PAGESIZE    := 4096
BOARD_KERNEL_TAGS_OFFSET := 0x00000100
BOARD_RAMDISK_OFFSET     := 0x01000000
BOARD_BOOTIMG_HEADER_VERSION := 1

BOARD_MKBOOTIMG_ARGS := --ramdisk_offset $(BOARD_RAMDISK_OFFSET) --tags_offset $(BOARD_KERNEL_TAGS_OFFSET) --header_version $(BOARD_BOOTIMG_HEADER_VERSION)

# Enable A/B partitions mechanism for the update engine
AB_OTA_UPDATER := true

AB_OTA_PARTITIONS += \
    boot \
    system \
    vendor \
    product

# =========================================================== #
# Kernel command line                                         #
# =========================================================== #
BOARD_KERNEL_CMDLINE := console=ttySTM0,115200 androidboot.console=ttySTM0 consoleblank=0
BOARD_KERNEL_CMDLINE += root=/dev/ram rw rootfstype=ext4 rootwait
BOARD_KERNEL_CMDLINE += init=/init firmware_class.path=/vendor/firmware
BOARD_KERNEL_CMDLINE += androidboot.hardware=stm

ifneq ($(TARGET_BUILD_VARIANT),user)

BOARD_KERNEL_CMDLINE += loglevel=8
BOARD_KERNEL_CMDLINE += printk.devkmsg=on
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive

# Enable graphic trace (graphic allocator and drm)
# BOARD_KERNEL_CMDLINE += gralloc.trace=1
# BOARD_KERNEL_CMDLINE += drm.debug=0x3f

# Enable dynamic debug (for file) on boot (change <path_to_file> by required kernel file)
# BOARD_KERNEL_CMDLINE += dyndbg=\"file <path_to_file> +p\"

# Enable atrace on boot for task scheduling
# BOARD_KERNEL_CMDLINE +=trace_buf_size=64M
# BOARD_KERNEL_CMDLINE +=trace_event=sched_wakeup,sched_switch,sched_blocked_reason

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
BOARD_HAVE_BLUETOOTH_LINUX := false
# BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR ?= device/stm/stm32mp1/$(BOARD_NAME)/network/bt
BOARD_SEPOLICY_DIRS += system/bt/vendor_libs/linux/sepolicy

# wi-fi configuration
ifeq ($(BOARD_WLAN_INTERFACE), wlan0)
BOARD_WLAN_DEVICE := stm
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_stm
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_stm
#WIFI_DRIVER_FW_PATH_AP := "/vendor/etc/firmware/htc_9271.fw"
#WIFI_DRIVER_FW_PATH_STA := "/vendor/etc/firmware/htc_9271.fw"
#WIFI_DRIVER_FW_PATH_P2P := "/vendor/etc/firmware/htc_9271.fw"
else
error BOARD_WLAN_INTERFACE wrongly defined
endif

# graphics configuration
BOARD_GPU_DRIVERS := vivante
USE_OPENGL_RENDERER := true

TARGET_USE_PRIVATE_LIBDRM := false
TARGET_USES_HWC2 := true
BOARD_USES_DRM_HWCOMPOSER_STM := true
BOARD_DRM_HWCOMPOSER_BUFFER_IMPORTER := stm32mpu

VSYNC_EVENT_PHASE_OFFSET_NS := 2000000
SF_VSYNC_EVENT_PHASE_OFFSET_NS := 6000000
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

# =========================================================== #
# General configuration                                       #
# =========================================================== #

# vendor manifest and compatibility matrix
DEVICE_MANIFEST_FILE := device/stm/stm32mp1/$(BOARD_NAME)/manifest.xml
DEVICE_MATRIX_FILE := device/stm/stm32mp1/$(BOARD_NAME)/compatibility_matrix.xml

# use mke2fs to create ext4 images
TARGET_USES_MKE2FS := true

# sepolicy
BOARD_SEPOLICY_DIRS += device/stm/stm32mp1/$(BOARD_NAME)/sepolicy

# properties
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true

# vndk
BOARD_VNDK_VERSION := current

# lowram device
MALLOC_SVELTE := true
