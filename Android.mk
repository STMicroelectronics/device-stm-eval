#
# Copyright (C) 2017 The Android Open-Source Project
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

ifneq ($(filter %eval, $(TARGET_PRODUCT)),)

LOCAL_PATH := $(call my-dir)

# if some modules are built directly from this directory (not subdirectories),
# their rules should be written here.

include $(CLEAR_VARS)
LOCAL_MODULE := remove-BlockedNumberProvider
EXECUTABLES.remove-BlockedNumberProvider.OVERRIDES := BlockedNumberProvider
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := remove-TeleService
EXECUTABLES.remove-TeleService.OVERRIDES := TeleService
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := remove-MmsService
EXECUTABLES.remove-MmsService.OVERRIDES := MmsService
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := remove-Telecom
EXECUTABLES.remove-Telecom.OVERRIDES := Telecom
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := remove-Bluetooth
EXECUTABLES.remove-Bluetooth.OVERRIDES := Bluetooth
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := remove-MusicFX
EXECUTABLES.remove-MusicFX.OVERRIDES := MusicFX
include $(BUILD_PHONY_PACKAGE)

include $(CLEAR_VARS)
LOCAL_MODULE := remove-NfcNci
EXECUTABLES.remove-NfcNci.OVERRIDES := NfcNci
include $(BUILD_PHONY_PACKAGE)

include $(call all-makefiles-under,$(LOCAL_PATH))
endif
