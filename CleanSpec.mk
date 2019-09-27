# Copyright 2017 The Android Open Source Project
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

# If you don't need to do a full clean build but would like to touch
# a file or delete some intermediate files, add a clean step to the end
# of the list.  These steps will only be run once, if they haven't been
# run before.
#
# E.g.:
#     $(call add-clean-step, touch -c external/sqlite/sqlite3.h)
#     $(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/STATIC_LIBRARIES/libz_intermediates)
#
# Always use "touch -c" and "rm -f" or "rm -rf" to gracefully deal with
# files that are missing or have been moved.
#
# Use $(PRODUCT_OUT) to get to the "out/target/product/blah/" directory.
# Use $(OUT_DIR) to refer to the "out" directory.
#
# If you need to re-do something that's already mentioned, just copy
# the command and add it to the bottom of the list.  E.g., if a change
# that you made last week required touching a file and a change you
# made today requires touching the same file, just copy the old
# touch step and add it to the end of the list.
#
# ************************************************
# NEWER CLEAN STEPS MUST BE AT THE END OF THE LIST
# ************************************************

# For example:
#$(call add-clean-step, rm -rf $(OUT_DIR)/target/common/obj/APPS/AndroidTests_intermediates)
#$(call add-clean-step, rm -rf $(OUT_DIR)/target/common/obj/JAVA_LIBRARIES/core_intermediates)
#$(call add-clean-step, find $(OUT_DIR) -type f -name "IGTalkSession*" -print0 | xargs -0 rm -f)
#$(call add-clean-step, rm -rf $(PRODUCT_OUT)/data/*)

$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/ueventd.rc)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/bin/initdriver)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/etc/fstab.stm)

$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant.conf)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/etc/bt/bd_addr.txt)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/firmware/rtlwifi/rtl8723aufw_A.bin)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/firmware/rtlwifi/rtl8723aufw_B.bin)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/firmware/rtlwifi/rtl8723aufw_B_NoBT.bin)

$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/etc/audio.$(BOARD_NAME).xml)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml)

$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles.xml)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video_limited.xml)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy)

$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/etc/permissions/*)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/firmware/*)

$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/fsbl.img)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/ssbl.img)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/splash.img)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/teeh.img)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/teed.img)
$(call add-clean-step, rm -rf $(PRODUCT_OUT)/$(TARGET_COPY_OUT_VENDOR)/teex.img)
