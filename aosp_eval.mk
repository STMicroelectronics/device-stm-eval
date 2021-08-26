#
# Copyright 2017 The Android Open-Source Project
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

# Soc family used to define device/$(SOC_FAMILY)
SOC_FAMILY := stm32mp1

# Soc name and version used to define bootloader required configuration
SOC_NAME := stm32mp15
SOC_VERSION := stm32mp157f

# Board name used to define device/$(SOC_FAMILY)/$(BOARD_NAME)/
BOARD_NAME := eval

# Board config used to define required configuration (only aosp up to now)
BOARD_CONFIG := aosp

# Board flavour used to define required configuration (ev1)
BOARD_FLAVOUR ?= ev1

# Board option (normal, empty, demo, demost)
BOARD_OPTION ?= normal

# Board display option (mb1230 or mb1166)
BOARD_DISPLAY_PANEL ?= mb1230

# Board disk type (sd, emmc)
ifdef STM32MP1_DISK_TYPE
BOARD_DISK_TYPE ?= $(STM32MP1_DISK_TYPE)
else
$(error STM32MP1_DISK_TYPE not defined!!)
endif

# Inherit from the Android Open Source Product configuration
$(call inherit-product, frameworks/native/build/phone-xhdpi-1024-dalvik-heap.mk)
$(call inherit-product, device/stm/stm32mp1/$(BOARD_NAME)/device.mk)
$(call inherit-product-if-exists, frameworks/base/data/sounds/AudioPackageGo.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_no_telephony.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/go_defaults.mk)

# Inherit from the Google Mobile Service configuration if available
$(call inherit-product-if-exists, vendor/google/products/gms.mk)

PRODUCT_NAME := $(BOARD_CONFIG)_$(BOARD_NAME)
PRODUCT_DEVICE := $(BOARD_NAME)
PRODUCT_BRAND := Android
PRODUCT_MODEL := Android $(BOARD_CONFIG) on $(SOC_VERSION)-${BOARD_FLAVOUR}
PRODUCT_MANUFACTURER := STMicroelectronics
PRODUCT_RESTRICT_VENDOR_FILES := false
