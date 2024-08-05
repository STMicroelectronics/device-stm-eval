#
# Copyright 2016 The Android Open-Source Project
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

$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)

PRODUCT_CHARACTERISTICS := nosdcard
PRODUCT_SHIPPING_API_LEVEL = 33

# Uncomment if a forbidden kernel config shall be set for debug purpose
# PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false

PRODUCT_USE_DYNAMIC_PARTITIONS := true

PRODUCT_SOONG_NAMESPACES += \
	device/stm/stm32mp2 \
	vendor/stm/app

# added only for compatibility (not used)
PRODUCT_SOONG_NAMESPACES += external/mesa3d

# added for v4l2 codec2
PRODUCT_SOONG_NAMESPACES += external/v4l2_codec2

PRODUCT_MANIFEST_FILES += device/stm/stm32mp2/$(BOARD_NAME)/product_manifest.xml
SYSTEM_EXT_MANIFEST_FILES += device/stm/stm32mp2/$(BOARD_NAME)/system_ext_manifest.xml

# Enable DM file pre-opting to reduce first boot time
PRODUCT_DEX_PREOPT_GENERATE_DM_FILES := true
PRODUCT_DEX_PREOPT_DEFAULT_COMPILER_FILTER := verify

DONT_UNCOMPRESS_PRIV_APPS_DEXS := true

PRODUCT_PROPERTY_OVERRIDES += ro.control_privapp_permissions=enforce

# Set default ringtone and notification sounds
PRODUCT_PROPERTY_OVERRIDES += \
	ro.config.ringtone=Ring_Synth_04.ogg \
	ro.config.notification_sound=pixiedust.ogg

# Reduces GC frequency of foreground apps by 50%
PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.foreground-heap-growth-multiplier=2.0

# Setting Overlay
DEVICE_PACKAGE_OVERLAYS := device/stm/stm32mp2/$(BOARD_NAME)/overlay

# Build and run only ART
PRODUCT_RUNTIMES := runtime_libart_default

# ZRAM writeback (default values)
PRODUCT_PROPERTY_OVERRIDES += \
	ro.zram.mark_idle_delay_mins=60 \
	ro.zram.first_wb_delay_mins=180 \
	ro.zram.periodic_wb_delay_hours=24

PRODUCT_PACKAGES += \
	watchdogd

PRODUCT_PROPERTY_OVERRIDES += /
	android.flash.info.available=false

PRODUCT_PROPERTY_OVERRIDES += \
	debug.sf.nobootanimation=1

#### INIT BEGIN ####

# Init
PRODUCT_COPY_FILES += \
	device/stm/stm32mp2-kernel/prebuilt/kernel-$(SOC_FAMILY):kernel \
	device/stm/stm32mp2/$(BOARD_NAME)/task_profiles.json:$(TARGET_COPY_OUT_VENDOR)/etc/task_profiles.json \
	device/stm/stm32mp2/$(BOARD_NAME)/init.recovery.stm.rc:${TARGET_COPY_OUT_RECOVERY}/root/init.recovery.stm.rc \
	device/stm/stm32mp2/$(BOARD_NAME)/init.stm.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.stm.rc \
	device/stm/stm32mp2/$(BOARD_NAME)/init.stm.network.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.stm.network.rc \
	device/stm/stm32mp2/$(BOARD_NAME)/init.stm.security.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.stm.security.rc \
	device/stm/stm32mp2/$(BOARD_NAME)/init.stm.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.stm.usb.rc

PRODUCT_COPY_FILES += \
	device/stm/stm32mp2/$(BOARD_NAME)/ueventd.stm.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc

# Scripts for init
PRODUCT_COPY_FILES += \
	device/stm/stm32mp2/$(BOARD_NAME)/init.stm.sh:$(TARGET_COPY_OUT_VENDOR)/bin/initdriver

# fstab
ifeq ($(BOARD_DISK_TYPE),emmc)
# eMMC AVB configuration (impact boot time)
ifeq ($(BOARD_DISK_HYBRID),false)
# case emmc AVB enabled
PRODUCT_COPY_FILES += \
	device/stm/stm32mp2/$(BOARD_NAME)/fstab_$(BOARD_DISK_TYPE)_avb.stm:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.stm \
	device/stm/stm32mp2/$(BOARD_NAME)/fstab_$(BOARD_DISK_TYPE)_avb.stm:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.stm \
	device/stm/stm32mp2/$(BOARD_NAME)/fstab_$(BOARD_DISK_TYPE).stm:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.stm
else
# case hybrid emmc/sd AVB enabled (sd for data) - test purpose
PRODUCT_COPY_FILES += \
	device/stm/stm32mp2/$(BOARD_NAME)/fstab_hybrid_avb.stm:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.stm \
	device/stm/stm32mp2/$(BOARD_NAME)/fstab_hybrid_avb.stm:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.stm \
	device/stm/stm32mp2/$(BOARD_NAME)/fstab_hybrid.stm:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.stm
endif
else
# case micro sd
PRODUCT_COPY_FILES += \
	device/stm/stm32mp2/$(BOARD_NAME)/fstab_$(BOARD_DISK_TYPE).stm:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.stm \
	device/stm/stm32mp2/$(BOARD_NAME)/fstab_$(BOARD_DISK_TYPE).stm:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.stm \
	device/stm/stm32mp2/$(BOARD_NAME)/fstab_$(BOARD_DISK_TYPE).stm:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.stm
endif
#### INIT END ####

#### GRAPHICS BEGIN ####

# Display & Graphics configuration
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
	ro.surface_flinger.use_context_priority=false \
	ro.surface_flinger.max_frame_buffer_acquired_buffers=3 \
	ro.surface_flinger.has_HDR_display=false \
	ro.surface_flinger.ignore_hdr_camera_layers=true \
	ro.surface_flinger.default_composition_dataspace=281083904

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += debug.stagefright.c2inputsurface=3

TARGET_GRALLOC_HAL := stm

# Graphics HAL (legacy)
PRODUCT_PACKAGES += \
	libdrm \
	libdrm_vivante \
	gralloc.$(TARGET_GRALLOC_HAL)

# OpenGLES version = 3.1 (0x00030001 = 196609)
PRODUCT_PROPERTY_OVERRIDES += \
	ro.opengles.version=196609

# Graphics GPU libraries
PRODUCT_PACKAGES += \
	libGLESv2_VIVANTE \
	libEGL_VIVANTE \
	libGLESv1_CM_VIVANTE \
	libGAL \
	libGLSLC \
	libVSC

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
	frameworks/native/data/etc/android.software.opengles.deqp.level-2022-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml

PRODUCT_PROPERTY_OVERRIDES += \
	ro.hardware.gralloc=$(TARGET_GRALLOC_HAL)

# Enable gralloc trace (disabled by default)
# PRODUCT_PROPERTY_OVERRIDES += \
# 	vendor.gralloc.trace=1

# composer: disable overlay planes usage
PRODUCT_PROPERTY_OVERRIDES += \
	vendor.hwc.drm.use_overlay_planes=0

# Graphics hardware service
PRODUCT_PACKAGES += \
	android.hardware.graphics.allocator@2.0-service \
	android.hardware.graphics.allocator@2.0-impl \
	android.hardware.graphics.mapper@2.0-impl-2.1 \
	android.hardware.graphics.composer3-service.stm32mpu

#### GRAPHICS END ####

#### AUDIO BEGIN ####

# disable audio on EVAL (not available)
PRODUCT_PROPERTY_OVERRIDES += \
	vendor.disable_audio=true

# default configuration, not used
PRODUCT_COPY_FILES += \
	device/stm/stm32mp2/$(BOARD_NAME)/media/audio/audio.stm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio.$(BOARD_NAME).xml

PRODUCT_COPY_FILES += \
	device/stm/stm32mp2/$(BOARD_NAME)/media/audio/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml

USE_XML_AUDIO_POLICY_CONF := 1
PRODUCT_COPY_FILES += \
	frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
	frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
	device/stm/stm32mp2/$(BOARD_NAME)/media/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml

# Audio hardware service
PRODUCT_PACKAGES += \
	android.hardware.audio.service \
	android.hardware.audio@6.0-impl \
	android.hardware.audio.effect@6.0-impl \
	libaudio-resampler \
	libeffects

TARGET_PRIMARYAUDIO_HAL := stm
TARGET_USBAUDIO_HAL := default
TARGET_REMOTESUBMIX_AUDIO_HAL := default

# Audio Primary HAL (legacy)
PRODUCT_PACKAGES += \
	libtinyalsa \
	libaudiohalcm \
	audio.primary.$(TARGET_PRIMARYAUDIO_HAL)

# Audio tools (for debug purpose)
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
	tinyplay \
	tinycap \
	tinymix \
	tinypcminfo
endif

# Audio USB HAL (legacy)
PRODUCT_PACKAGES += \
	audio.usb.$(TARGET_USBAUDIO_HAL)

# Audio Remote Submix HAL (legacy)
PRODUCT_PACKAGES += \
	audio.r_submix.$(TARGET_REMOTESUBMIX_AUDIO_HAL)

PRODUCT_PROPERTY_OVERRIDES += \
	ro.hardware.audio.primary=$(TARGET_PRIMARYAUDIO_HAL) \
	ro.hardware.audio.usb=$(TARGET_USBAUDIO_HAL)

# audio feature declaration
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.audio.output.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.output.xml \

#### AUDIO END ####

#### CAMERA BEGIN ####

PRODUCT_PACKAGES += \
	android.hardware.camera.provider-service.stm32mpu

PRODUCT_PACKAGES += \
	media-ctl \
	v4l2-ctl

PRODUCT_COPY_FILES += \
	device/stm/stm32mp2/${BOARD_NAME}/media/camera/metadata_definitions.xml:$(TARGET_COPY_OUT_VENDOR)/etc/config/metadata_definitions.xml

# camera init
PRODUCT_COPY_FILES += \
	device/stm/stm32mp2/$(BOARD_NAME)/init.stm.camera.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.stm.camera.rc \
	device/stm/stm32mp2/$(BOARD_NAME)/media/camera/camera-setup.sh:$(TARGET_COPY_OUT_VENDOR)/bin/camerasetup

# external camera feature declaration
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.camera.external.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.external.xml \
	frameworks/native/data/etc/android.hardware.camera.autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.autofocus.xml \

# Camera topology configuration (preview = aux, record = main)
PRODUCT_PROPERTY_OVERRIDES += \
	vendor.camera.aux.width=640 \
	vendor.camera.aux.height=480 \
	vendor.camera.aux.format=RGB565_2X8_LE \
	vendor.camera.main.width=1024 \
	vendor.camera.main.height=768 \
	vendor.camera.main.format=YUYV8_2X8 \
	vendor.camera.isp.update.frequency=5000

#### CAMERA END ####

#### VIDEO BEGIN ####

# Media configuration
PRODUCT_COPY_FILES += \
	device/stm/stm32mp2/$(BOARD_NAME)/media/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
	device/stm/stm32mp2/$(BOARD_NAME)/media/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
	device/stm/stm32mp2/$(BOARD_NAME)/media/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml \
	device/stm/stm32mp2/$(BOARD_NAME)/media/video/media_codecs_google_c2_video_limited.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2_video_limited.xml \
	frameworks/av/media/libstagefright/data/media_codecs_google_c2_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2_audio.xml

# Media seccomp policy file
PRODUCT_COPY_FILES += \
	device/stm/stm32mp2/$(BOARD_NAME)/media/mediacodec.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/codec2.vendor.ext.policy

# Video codec2
PRODUCT_PACKAGES += \
	android.hardware.media.c2@1.0-service-v4l2 \
	libv4l2_codec2_vendor_allocator \
	libc2plugin_store

# Set the customized property of v4l2_codec2, including:
#   The maximum concurrent instances for decoder/encoder.
#   It should be the same as "concurrent-instances" at media_codec_c2.xml.
PRODUCT_PROPERTY_OVERRIDES += \
	ro.vendor.v4l2_codec2.decode_concurrent_instances=8 \
	ro.vendor.v4l2_codec2.encode_concurrent_instances=8

# Enable Codec 2.0
PRODUCT_PROPERTY_OVERRIDES += \
	debug.media.codec2=2 \
	debug.stagefright.ccodec=4 \
	debug.stagefright.omx_default_rank=512 \
	debug.c2.use_dmabufheaps=1

PRODUCT_PROPERTY_OVERRIDES += \
	ro.vendor.v4l2_codec2.decode.device=/dev/video0 \
	ro.vendor.v4l2_codec2.decode.media=/dev/media0

# Codec2.0 poolMask:
#   DMABUFHEAP(16) (replacing ION)
#   BUFFERQUEUE(18)
#   BLOB(19)
#   V4L2_BUFFERQUEUE(20)
#   V4L2_BUFFERPOOL(21)
#   SECURE_LINEAR(22)
#   SECURE_GRAPHIC(23)
#
# For linear buffer allocation:
#   If DMABUFHEAP is chosen, then the mask should be 0xf50000
#   If BLOB is chosen, then the mask should be 0xfc0000
PRODUCT_PROPERTY_OVERRIDES += \
	debug.stagefright.c2-poolmask=0xf50000

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PROPERTY_OVERRIDES += \
	debug.force_low_ram=true
endif

# Disable OMX
PRODUCT_PROPERTY_OVERRIDES += \
	vendor.media.omx=0

#### VIDEO END ####

#### SECURITY BEGIN ####

# set adiantum crypto (software)
PRODUCT_PROPERTY_OVERRIDES += \
	ro.crypto.volume.options=adiantum \
	ro.crypto.volume.metadata.encryption=adiantum

# Keymaster hardware service
PRODUCT_PACKAGES += \
	android.hardware.keymaster@3.0-service.optee \
	wait_for_keymaster_optee

# Keymint software service
PRODUCT_PACKAGES += \
	android.hardware.security.keymint-service

# Keymaster OP-TEE TA
PRODUCT_COPY_FILES += \
	device/stm/stm32mp2-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/dba51a17-0563-11e7-93b1-6fa7b0071a51.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/dba51a17-0563-11e7-93b1-6fa7b0071a51.ta

# Gatekeeper hardware service
PRODUCT_PACKAGES += \
	android.hardware.gatekeeper@1.0-service.optee

# Gatekeeper OP-TEE TA
PRODUCT_COPY_FILES += \
	device/stm/stm32mp2-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/4d573443-6a56-4272-ac6f-2425af9ef9bb.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/4d573443-6a56-4272-ac6f-2425af9ef9bb.ta

# TEE hardware service
PRODUCT_PACKAGES += \
	tee-supplicant \
	libteec

# TEE tests
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
	xtest

PRODUCT_COPY_FILES += \
	device/stm/stm32mp2-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/e626662e-c0e2-485c-b8c8-09fbce6edf3d.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/e626662e-c0e2-485c-b8c8-09fbce6edf3d.ta \
	device/stm/stm32mp2-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/e13010e0-2ae1-11e5-896a-0002a5d5c51b.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/e13010e0-2ae1-11e5-896a-0002a5d5c51b.ta \
	device/stm/stm32mp2-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/5ce0c432-0ab0-40e5-a056-782ca0e6aba2.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/5ce0c432-0ab0-40e5-a056-782ca0e6aba2.ta \
	device/stm/stm32mp2-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/c3f6e2c0-3548-11e1-b86c-0800200c9a66.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/c3f6e2c0-3548-11e1-b86c-0800200c9a66.ta \
	device/stm/stm32mp2-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/cb3e5ba0-adf1-11e0-998b-0002a5d5c51b.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/cb3e5ba0-adf1-11e0-998b-0002a5d5c51b.ta \
	device/stm/stm32mp2-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/ffd2bded-ab7d-4988-95ee-e4962fff7154.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/ffd2bded-ab7d-4988-95ee-e4962fff7154.ta \
	device/stm/stm32mp2-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/5b9e0e40-2636-11e1-ad9e-0002a5d5c51b.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/5b9e0e40-2636-11e1-ad9e-0002a5d5c51b.ta \
	device/stm/stm32mp2-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/12345678-5b69-11e4-9dbb-101f74f00099.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/12345678-5b69-11e4-9dbb-101f74f00099.ta \
	device/stm/stm32mp2-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/614789f2-39c0-4ebf-b235-92b32ac107ed.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/614789f2-39c0-4ebf-b235-92b32ac107ed.ta \
	device/stm/stm32mp2-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/e6a33ed4-562b-463a-bb7e-ff5e15a493c8.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/e6a33ed4-562b-463a-bb7e-ff5e15a493c8.ta \
	device/stm/stm32mp2-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/873bcd08-c2c3-11e6-a937-d0bf9c45c61c.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/873bcd08-c2c3-11e6-a937-d0bf9c45c61c.ta \
	device/stm/stm32mp2-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/b689f2a7-8adf-477a-9f99-32e90c0ad0a2.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/b689f2a7-8adf-477a-9f99-32e90c0ad0a2.ta \
	device/stm/stm32mp2-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/731e279e-aafb-4575-a771-38caa6f0cca6.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/731e279e-aafb-4575-a771-38caa6f0cca6.ta \
	device/stm/stm32mp2-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/d17f73a0-36ef-11e1-984a-0002a5d5c51b.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/d17f73a0-36ef-11e1-984a-0002a5d5c51b.ta \
	device/stm/stm32mp2-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/f157cda0-550c-11e5-a6fa-0002a5d5c51b.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/f157cda0-550c-11e5-a6fa-0002a5d5c51b.ta \
	device/stm/stm32mp2-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/528938ce-fc59-11e8-8eb2-f2801f1b9fd1.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/528938ce-fc59-11e8-8eb2-f2801f1b9fd1.ta \
	device/stm/stm32mp2-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/b3091a65-9751-4784-abf7-0298a7cc35ba.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/b3091a65-9751-4784-abf7-0298a7cc35ba.ta \
	device/stm/stm32mp2-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/a4c04d50-f180-11e8-8eb2-f2801f1b9fd1.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/a4c04d50-f180-11e8-8eb2-f2801f1b9fd1.ta
endif

PRODUCT_PACKAGES += \
	android.hardware.oemlock@1.0-service.stm32mpu

#### SECURITY END ####

#### NETWORK START ####

# Set this value here as BoardConfig.mk is parsed later
BOARD_WLAN_INTERFACE := wlan0

# Wireless configuration
PRODUCT_COPY_FILES += \
	device/stm/stm32mp2/$(BOARD_NAME)/network/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf \
	device/stm/stm32mp2/$(BOARD_NAME)/firmware/rtlwifi/rtl8723aufw_A.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/rtlwifi/rtl8723aufw_A.bin \
	device/stm/stm32mp2/$(BOARD_NAME)/firmware/rtlwifi/rtl8723aufw_B.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/rtlwifi/rtl8723aufw_B.bin \
	device/stm/stm32mp2/$(BOARD_NAME)/firmware/rtlwifi/rtl8723aufw_B_NoBT.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/rtlwifi/rtl8723aufw_B_NoBT.bin \
	device/stm/stm32mp2/$(BOARD_NAME)/firmware/htcwifi/htc_9271.fw:$(TARGET_COPY_OUT_VENDOR)/firmware/htc_9271.fw

# Wi-Fi hardware service
PRODUCT_PACKAGES += \
	android.hardware.wifi@1.0-service

# Control Flow Integrity enabled for Wi-Fi libraries
PRODUCT_CFI_INCLUDE_PATHS += \
	device/stm/stm32mp2/eval/network/wifi/wpa_supplicant_8_lib

# Network
PRODUCT_PACKAGES += \
	libwpa_client \
	hostapd \
	wpa_supplicant \
	wpa_supplicant.conf

PRODUCT_PACKAGES += \
	wificond \
	wifilogd

# Set product properties
PRODUCT_PRODUCT_PROPERTIES += \
	ro.tether.denied=false

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml \
	frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml

#### NETWORK END ####

#### USB START ####

# USB hardware service
PRODUCT_PACKAGES += \
	android.hardware.usb-service.stm32mpu \
	android.hardware.usb.gadget@1.2-service.stm32mpu

PRODUCT_PROPERTY_OVERRIDES += \
	vendor.usb.rndis.config=rndis.0 \
	vendor.usb.ncm.config=ncm.0

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
	frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml

#### USB END ####

#### SYSTEM START ####

# Lights hardware service
PRODUCT_PACKAGES += \
	android.hardware.lights-service.stm32mpu

# Dumpstate hardware service
PRODUCT_PACKAGES += \
	android.hardware.dumpstate-service.stm32mpu.$(BOARD_NAME)

# Thermal hardware service
PRODUCT_PACKAGES += \
	android.hardware.thermal@2.0-service.stm32mpu

# Power hardware service
PRODUCT_PACKAGES += \
	android.hardware.power-service.example

# Memtrack hardware service
PRODUCT_PACKAGES += \
	android.hardware.memtrack-service.stm32mpu

# Boot control hardware service
PRODUCT_PACKAGES += \
	android.hardware.boot@1.2-service \
	android.hardware.boot@1.2-impl \
	android.hardware.boot@1.2-impl.recovery

# Health hardware service
PRODUCT_PACKAGES += \
    android.hardware.health-service.stm32mpu.$(BOARD_DISK_TYPE) \
    android.hardware.health-service.stm32mpu_recovery.$(BOARD_DISK_TYPE)

# Fastboot hardware service
PRODUCT_PACKAGES += \
	android.hardware.fastboot@1.0 \
	android.hardware.fastboot@1.0-impl-mock \
	fastbootd

# Permissions
PRODUCT_COPY_FILES += device/stm/stm32mp2/$(BOARD_NAME)/st_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/st_core_hardware.xml

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.faketouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.faketouch.xml \
	frameworks/native/data/etc/android.software.backup.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.backup.xml \
	frameworks/native/data/etc/android.hardware.screen.landscape.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.screen.landscape.xml \
	frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml

#### SYSTEM START ####

# Memory
PRODUCT_PACKAGES += \
	libion

# VNDK libraries
PRODUCT_PACKAGES += vndk_package

# Update engine
PRODUCT_PACKAGES += \
	update_engine \
	update_verifier

PRODUCT_PACKAGES += \
	update_engine_sideload

# Set product properties
PRODUCT_PRODUCT_PROPERTIES += \
	ro.sys.sdcardfs=1 \
	ro.iorapd.enable=false

# Allows healthd to boot directly from charger mode rather than initiating a reboot.
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
	ro.enable_boot_charger_mode=1

# for off charging mode
PRODUCT_PACKAGES += \
	charger_res_images

# for systrace
# PRODUCT_PROPERTY_OVERRIDES += \
#	debug.atrace.tags.enableflags=802922 \
#	persist.traced.enable=0

PRODUCT_PACKAGES += \
	stagefright

PRODUCT_PROPERTY_OVERRIDES += \
	ro.radio.noril=yes

#### ST CUSTOM START ####

ifeq ($(BOARD_OPTION),st)

# /system_ext packages (override)
PRODUCT_PACKAGES += \
    Launcher3QuickStepGo

# remove unecessary system packages
PRODUCT_PACKAGES += \
	remove-BlockedNumberProvider \
	remove-Telecom \
	remove-TeleService \
	remove-MmsService \
	remove-NfcNci \
	remove-MusicFX

PRODUCT_PACKAGES += \
	STLauncher \
	STVideo \
	STGraphics

# ST applications compiled with the speed compiler filter
PRODUCT_DEXPREOPT_SPEED_APPS += \
	STLauncher \
	STVideo \
	STGraphics

# Integrate STPerf only in debug build
ifneq ($(TARGET_BUILD_VARIANT),user)

PRODUCT_PACKAGES += \
	STPerf

# ST applications compiled with the speed compiler filter
PRODUCT_DEXPREOPT_SPEED_APPS += \
	STPerf

endif

PRODUCT_COPY_FILES += \
	device/stm/stm32mp2/$(BOARD_NAME)/wallpaper/st_background_1024x600.bmp:$(TARGET_COPY_OUT_PRODUCT)/media/wallpaper/wallpaper.bmp

PRODUCT_PRODUCT_PROPERTIES += \
	ro.config.wallpaper=/product/media/wallpaper/wallpaper.bmp

endif

#### ST CUSTOM END ####

# Android Live-LocK Daemon (catch kernel deadlocks and mitigate). Useful for VTS
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
	llkd

PRODUCT_SET_DEBUGFS_RESTRICTIONS := false
endif

# STM32 image wrapper. Useful for GDB/OpenOCD (debug)
ifneq ($(TARGET_BUILD_VARIANT),user)
#PRODUCT_HOST_PACKAGES += \
#	stm32wrapper4dbg
endif

PRODUCT_PACKAGES += \
    netutils-wrapper-1.0

# SDK add-on generation
ifneq ($(filter sdk win_sdk sdk_addon,$(MAKECMDGOALS)),)
# Generate SDK only in Eng build variant
ifneq ($(TARGET_BUILD_VARIANT),eng)
$(error Eng build variant must be set to generate SDK. Current build variant is $(TARGET_BUILD_VARIANT), please use lunch command to select eng build variant.)
endif
endif
