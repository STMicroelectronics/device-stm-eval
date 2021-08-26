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

PRODUCT_CHARACTERISTICS := nosdcard
PRODUCT_SHIPPING_API_LEVEL = 30

# Uncomment if a forbidden kernel config shall be set for debug purpose
# PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false

PRODUCT_USE_DYNAMIC_PARTITIONS := true

PRODUCT_SOONG_NAMESPACES += \
	device/stm/stm32mp1 \
	vendor/stm/app

# added only for compatibility (not used)
PRODUCT_SOONG_NAMESPACES += external/mesa3d

PRODUCT_MANIFEST_FILES += device/stm/stm32mp1/eval/product_manifest.xml
SYSTEM_EXT_MANIFEST_FILES += device/stm/stm32mp1/eval/system_ext_manifest.xml

# Enable DM file pre-opting to reduce first boot time
PRODUCT_DEX_PREOPT_GENERATE_DM_FILES := true
PRODUCT_DEX_PREOPT_DEFAULT_COMPILER_FILTER := verify

DONT_UNCOMPRESS_PRIV_APPS_DEXS := true

# Set default ringtone and notification sounds
PRODUCT_PROPERTY_OVERRIDES += \
	ro.config.ringtone=Ring_Synth_04.ogg \
	ro.config.notification_sound=pixiedust.ogg

# Reduces GC frequency of foreground apps by 50%
PRODUCT_PROPERTY_OVERRIDES += dalvik.vm.foreground-heap-growth-multiplier=2.0

BOARD_USES_TINYHAL_AUDIO := true
USE_XML_AUDIO_POLICY_CONF := 1

# Setting Overlay
DEVICE_PACKAGE_OVERLAYS := device/stm/stm32mp1/$(BOARD_NAME)/overlay

# Build and run only ART
PRODUCT_RUNTIMES := runtime_libart_default

# Set this value here as BoardConfig.mk is parsed later
BOARD_WLAN_INTERFACE := wlan0

# ZRAM writeback (default values)
PRODUCT_PROPERTY_OVERRIDES += \
	ro.zram.mark_idle_delay_mins=60 \
	ro.zram.first_wb_delay_mins=180 \
	ro.zram.periodic_wb_delay_hours=24

#-- Android legacy HALs --
TARGET_USBAUDIO_HAL := default
TARGET_PRIMARYAUDIO_HAL := stm
TARGET_USBCAM_HAL := stm
TARGET_GRALLOC_HAL := stm
TARGET_COMPOSER_HAL := drm_stm32mp1
TARGET_MEMTRACK_HAL := stm
TARGET_REMOTESUBMIX_AUDIO_HAL := default

PRODUCT_PACKAGES += \
	watchdogd

# Android Live-LocK Daemon (catch kernel deadlocks and mitigate). Useful for VTS
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
	llkd
endif

# AUDIO USB HAL module
PRODUCT_PACKAGES += \
	audio.usb.$(TARGET_USBAUDIO_HAL)

# AUDIO PRIMARY HAL and associated modules
PRODUCT_PACKAGES += \
	libtinyalsa \
	tinyplay \
	tinycap \
	tinymix \
	tinypcminfo \
	libaudiohalcm \
	audio.primary.$(TARGET_PRIMARYAUDIO_HAL)

# AUDIO REMOTE SUBMIX HAL
PRODUCT_PACKAGES += \
	audio.r_submix.$(TARGET_REMOTESUBMIX_AUDIO_HAL)

PRODUCT_PACKAGES += \
	android.hardware.camera.provider@2.4-service.stm32mp1

PRODUCT_PROPERTY_OVERRIDES += /
	android.flash.info.available=false

PRODUCT_PACKAGES += \
	android.hardware.oemlock@1.0-service.stm32mp1

# Copro HAL module
PRODUCT_PACKAGES += \
	android.hardware.copro@1.0-service.stm32mp1 \
	CoproService

# Cube-M4-Examples Firmware
PRODUCT_PACKAGES += \
	fw_cortex_m4_$(BOARD_NAME).sh

PRODUCT_COPY_FILES += \
	device/stm/stm32mp1/$(BOARD_NAME)/firmware/Cube-M4-examples/Examples/ADC_SingleConversion_TriggerTimer_DMA/ADC_SingleConversion_TriggerTimer_DMA.elf:$(TARGET_COPY_OUT_VENDOR)/firmware/Cube-M4-examples/${SOC_VERSION}/Examples/ADC_SingleConversion_TriggerTimer_DMA/ADC_SingleConversion_TriggerTimer_DMA.elf \
	device/stm/stm32mp1/$(BOARD_NAME)/firmware/Cube-M4-examples/Examples/ADC_SingleConversion_TriggerTimer_DMA/README:$(TARGET_COPY_OUT_VENDOR)/firmware/Cube-M4-examples/${SOC_VERSION}/Examples/ADC_SingleConversion_TriggerTimer_DMA/README \
	device/stm/stm32mp1/$(BOARD_NAME)/firmware/Cube-M4-examples/Examples/ADC_SingleConversion_TriggerTimer_DMA/ADC_SingleConversion_TriggerTimer_DMA.elf:$(TARGET_COPY_OUT_VENDOR)/firmware/Cube-M4-examples/${SOC_VERSION}/Examples/TIM_DMABurst/TIM_DMABurst.elf \
	device/stm/stm32mp1/$(BOARD_NAME)/firmware/Cube-M4-examples/Examples/ADC_SingleConversion_TriggerTimer_DMA/README:$(TARGET_COPY_OUT_VENDOR)/firmware/Cube-M4-examples/${SOC_VERSION}/Examples/TIM_DMABurst/README \

# WIFI HAL
PRODUCT_PACKAGES += \
	libwifi-hal-stm \
	lib_driver_cmd_stm

# Remove unnecessary packages
PRODUCT_PACKAGES += \
	remove-BlockedNumberProvider \
	remove-Telecom \
	remove-TeleService \
	remove-MmsService \
	remove-Bluetooth \
	remove-MusicFX \
	remove-NfcNci

# Display & Graphics configuration
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.vsync_event_phase_offset_ns=2000000
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.vsync_sf_event_phase_offset_ns=6000000

# Graphics HAL modules
PRODUCT_PACKAGES += \
	libdrm \
	libdrm_vivante \
	hwcomposer.$(TARGET_COMPOSER_HAL) \
	gralloc.$(TARGET_GRALLOC_HAL)

# Graphics GPU libraries
PRODUCT_PACKAGES += \
	libGLESv2_VIVANTE \
	libEGL_VIVANTE \
	libGLESv1_CM_VIVANTE \
	libGAL \
	libGLSLC \
	libVSC

# Enable gralloc trace (disabled by default)
# PRODUCT_PROPERTY_OVERRIDES += \
# 	vendor.gralloc.trace=1

PRODUCT_PROPERTY_OVERRIDES += \
	ro.hardware.gralloc=$(TARGET_GRALLOC_HAL) \
	ro.hardware.audio.primary=$(TARGET_PRIMARYAUDIO_HAL) \
	ro.hardware.audio.usb=$(TARGET_USBAUDIO_HAL) \
	ro.hardware.memtrack=$(TARGET_MEMTRACK_HAL) \
	ro.hardware.hwcomposer=$(TARGET_COMPOSER_HAL)

# Init
PRODUCT_COPY_FILES += \
	device/stm/stm32mp1-kernel/prebuilt/kernel-$(SOC_FAMILY):kernel \
	device/stm/stm32mp1/$(BOARD_NAME)/task_profiles.json:$(TARGET_COPY_OUT_VENDOR)/etc/task_profiles.json \
	device/stm/stm32mp1/$(BOARD_NAME)/init.recovery.stm.rc:root/init.recovery.stm.rc \
	device/stm/stm32mp1/$(BOARD_NAME)/init.stm.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.stm.rc \
	device/stm/stm32mp1/$(BOARD_NAME)/init.stm.network.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.stm.network.rc \
	device/stm/stm32mp1/$(BOARD_NAME)/init.stm.security.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.stm.security.rc \
	device/stm/stm32mp1/$(BOARD_NAME)/init.stm.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.stm.usb.rc

PRODUCT_COPY_FILES += \
	device/stm/stm32mp1/$(BOARD_NAME)/ueventd.stm.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc

# Scripts for init
PRODUCT_COPY_FILES += \
	device/stm/stm32mp1/$(BOARD_NAME)/init.stm.sh:$(TARGET_COPY_OUT_VENDOR)/bin/initdriver

# fstab
PRODUCT_COPY_FILES += \
	device/stm/stm32mp1/$(BOARD_NAME)/fstab_$(BOARD_DISK_TYPE).stm:$(TARGET_COPY_OUT_RAMDISK)/fstab.stm \
	device/stm/stm32mp1/$(BOARD_NAME)/fstab_$(BOARD_DISK_TYPE).stm:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.stm

# Wireless configuration
PRODUCT_COPY_FILES += \
	device/stm/stm32mp1/$(BOARD_NAME)/network/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf \
	device/stm/stm32mp1/$(BOARD_NAME)/network/wifi/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \
	device/stm/stm32mp1/$(BOARD_NAME)/firmware/rtlwifi/rtl8723aufw_A.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/rtlwifi/rtl8723aufw_A.bin \
	device/stm/stm32mp1/$(BOARD_NAME)/firmware/rtlwifi/rtl8723aufw_B.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/rtlwifi/rtl8723aufw_B.bin \
	device/stm/stm32mp1/$(BOARD_NAME)/firmware/rtlwifi/rtl8723aufw_B_NoBT.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/rtlwifi/rtl8723aufw_B_NoBT.bin \
	device/stm/stm32mp1/$(BOARD_NAME)/firmware/htcwifi/htc_9271.fw:$(TARGET_COPY_OUT_VENDOR)/firmware/htc_9271.fw

PRODUCT_COPY_FILES += \
	device/stm/stm32mp1/$(BOARD_NAME)/media/audio/audio.stm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio.$(BOARD_NAME).xml

PRODUCT_COPY_FILES += \
	device/stm/stm32mp1/$(BOARD_NAME)/media/audio/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml

PRODUCT_COPY_FILES += \
	frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
	frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
	device/stm/stm32mp1/$(BOARD_NAME)/media/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml

# Media configuration
PRODUCT_COPY_FILES += \
	device/stm/stm32mp1/$(BOARD_NAME)/media/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
	device/stm/stm32mp1/$(BOARD_NAME)/media/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
	device/stm/stm32mp1/$(BOARD_NAME)/media/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml \
	device/stm/stm32mp1/$(BOARD_NAME)/media/video/media_codecs_google_c2_video_limited.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2_video_limited.xml \
	frameworks/av/media/libstagefright/data/media_codecs_google_c2_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2_audio.xml

# Media seccomp policy file
PRODUCT_COPY_FILES += \
	device/stm/stm32mp1/$(BOARD_NAME)/media/mediacodec.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy

# Enable Codec 2.0
PRODUCT_PROPERTY_OVERRIDES += \
	debug.media.codec2=2 \
	debug.stagefright.ccodec=4 \
	debug.stagefright.omx_default_rank=512

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PROPERTY_OVERRIDES += \
	debug.force_low_ram=true
endif

# Disable OMX
PRODUCT_PROPERTY_OVERRIDES += \
	vendor.media.omx=0

# Graphics hardware service
PRODUCT_PACKAGES += \
	android.hardware.graphics.allocator@2.0-service \
	android.hardware.graphics.allocator@2.0-impl \
	android.hardware.graphics.mapper@2.0-impl-2.1 \
	android.hardware.graphics.composer@2.1-impl \
	android.hardware.graphics.composer@2.1-service

# Lights hardware service
PRODUCT_PACKAGES += \
	android.hardware.lights-service.stm32mp1

# Dumpstate hardware service
PRODUCT_PACKAGES += \
	android.hardware.dumpstate@1.1-service.$(BOARD_NAME)

# Keymaster hardware service
PRODUCT_PACKAGES += \
	android.hardware.keymaster@3.0-service.optee \
	wait_for_keymaster_optee

# Keymaster OP-TEE TA
PRODUCT_COPY_FILES += \
	device/stm/stm32mp1-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/dba51a17-0563-11e7-93b1-6fa7b0071a51.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/dba51a17-0563-11e7-93b1-6fa7b0071a51.ta

# Gatekeeper hardware service
PRODUCT_PACKAGES += \
	android.hardware.gatekeeper@1.0-service.optee

# Gatekeeper OP-TEE TA
PRODUCT_COPY_FILES += \
	device/stm/stm32mp1-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/4d573443-6a56-4272-ac6f-2425af9ef9bb.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/4d573443-6a56-4272-ac6f-2425af9ef9bb.ta

# Audio hardware service
PRODUCT_PACKAGES += \
	android.hardware.audio@2.0-service \
	android.hardware.audio@6.0-impl \
	android.hardware.audio.effect@6.0-impl \
	libaudio-resampler \
	libeffects

# Wi-Fi hardware service
PRODUCT_PACKAGES += \
	android.hardware.wifi@1.0-service

# USB hardware service
PRODUCT_PACKAGES += \
	android.hardware.usb@1.1-service.stm32mp1

# Thermal hardware service
PRODUCT_PACKAGES += \
	android.hardware.thermal@2.0-service.stm32mp1

# Power hardware service
PRODUCT_PACKAGES += \
	android.hardware.power-service.example

# Memtrack hardware service
PRODUCT_PACKAGES += \
	memtrack.$(TARGET_MEMTRACK_HAL) \
	android.hardware.memtrack@1.0-service \
	android.hardware.memtrack@1.0-impl

# Boot control hardware service
PRODUCT_PACKAGES += \
	android.hardware.boot@1.1-service \
	android.hardware.boot@1.1-impl

# Health hardware service
PRODUCT_PACKAGES += \
	android.hardware.health@2.1-impl-stm32mp1.$(BOARD_DISK_TYPE) \
	android.hardware.health@2.1-service

# TEE hardware service
PRODUCT_PACKAGES += \
	tee-supplicant \
	libteec

# TEE tests
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
	xtest

PRODUCT_COPY_FILES += \
	device/stm/stm32mp1-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/e626662e-c0e2-485c-b8c8-09fbce6edf3d.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/e626662e-c0e2-485c-b8c8-09fbce6edf3d.ta \
	device/stm/stm32mp1-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/e13010e0-2ae1-11e5-896a-0002a5d5c51b.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/e13010e0-2ae1-11e5-896a-0002a5d5c51b.ta \
	device/stm/stm32mp1-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/5ce0c432-0ab0-40e5-a056-782ca0e6aba2.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/5ce0c432-0ab0-40e5-a056-782ca0e6aba2.ta \
	device/stm/stm32mp1-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/c3f6e2c0-3548-11e1-b86c-0800200c9a66.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/c3f6e2c0-3548-11e1-b86c-0800200c9a66.ta \
	device/stm/stm32mp1-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/cb3e5ba0-adf1-11e0-998b-0002a5d5c51b.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/cb3e5ba0-adf1-11e0-998b-0002a5d5c51b.ta \
	device/stm/stm32mp1-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/ffd2bded-ab7d-4988-95ee-e4962fff7154.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/ffd2bded-ab7d-4988-95ee-e4962fff7154.ta \
	device/stm/stm32mp1-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/5b9e0e40-2636-11e1-ad9e-0002a5d5c51b.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/5b9e0e40-2636-11e1-ad9e-0002a5d5c51b.ta \
	device/stm/stm32mp1-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/12345678-5b69-11e4-9dbb-101f74f00099.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/12345678-5b69-11e4-9dbb-101f74f00099.ta \
	device/stm/stm32mp1-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/614789f2-39c0-4ebf-b235-92b32ac107ed.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/614789f2-39c0-4ebf-b235-92b32ac107ed.ta \
	device/stm/stm32mp1-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/e6a33ed4-562b-463a-bb7e-ff5e15a493c8.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/e6a33ed4-562b-463a-bb7e-ff5e15a493c8.ta \
	device/stm/stm32mp1-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/873bcd08-c2c3-11e6-a937-d0bf9c45c61c.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/873bcd08-c2c3-11e6-a937-d0bf9c45c61c.ta \
	device/stm/stm32mp1-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/b689f2a7-8adf-477a-9f99-32e90c0ad0a2.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/b689f2a7-8adf-477a-9f99-32e90c0ad0a2.ta \
	device/stm/stm32mp1-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/731e279e-aafb-4575-a771-38caa6f0cca6.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/731e279e-aafb-4575-a771-38caa6f0cca6.ta \
	device/stm/stm32mp1-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/d17f73a0-36ef-11e1-984a-0002a5d5c51b.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/d17f73a0-36ef-11e1-984a-0002a5d5c51b.ta \
	device/stm/stm32mp1-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/f157cda0-550c-11e5-a6fa-0002a5d5c51b.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/f157cda0-550c-11e5-a6fa-0002a5d5c51b.ta \
	device/stm/stm32mp1-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/528938ce-fc59-11e8-8eb2-f2801f1b9fd1.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/528938ce-fc59-11e8-8eb2-f2801f1b9fd1.ta \
	device/stm/stm32mp1-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/b3091a65-9751-4784-abf7-0298a7cc35ba.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/b3091a65-9751-4784-abf7-0298a7cc35ba.ta \
	device/stm/stm32mp1-tee/prebuilt/$(SOC_VERSION)-$(BOARD_FLAVOUR)/ta/a4c04d50-f180-11e8-8eb2-f2801f1b9fd1.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/a4c04d50-f180-11e8-8eb2-f2801f1b9fd1.ta
endif

# Permissions
ifeq ($(BOARD_CONFIG),aosp)
PRODUCT_COPY_FILES += device/stm/stm32mp1/$(BOARD_NAME)/st_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/st_core_hardware.xml
else ifeq ($(BOARD_CONFIG),wear)
PRODUCT_COPY_FILES += frameworks/native/data/etc/wearable_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/wearable_core_hardware.xml
else
$(error Unrecognized board configuration (BOARD_CONFIG) = $(BOARD_CONFIG))
endif

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.audio.output.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.output.xml \
	frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml \
	frameworks/native/data/etc/android.hardware.faketouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.faketouch.xml \
	frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
	frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
	frameworks/native/data/etc/android.software.backup.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.backup.xml \
	frameworks/native/data/etc/android.hardware.screen.portrait.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.screen.portrait.xml \
	frameworks/native/data/etc/android.hardware.screen.landscape.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.screen.landscape.xml \
	frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml

# Network
PRODUCT_PACKAGES += \
	libwpa_client \
	hostapd \
	wpa_supplicant \
	wpa_supplicant.conf

PRODUCT_PACKAGES += \
	wificond \
	wifilogd

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

# OpenGLES version = 2.0 (0x00020000 = 131072)
# Recommended LCD density = 240
PRODUCT_PROPERTY_OVERRIDES += \
	ro.opengles.version=131072 \
	ro.sf.lcd_density=240

# HWC disable overlay planes usage
PRODUCT_PROPERTY_OVERRIDES += \
	vendor.hwc.drm.use_overlay_planes=1

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

# Launcher application
ifeq ($(BOARD_OPTION),normal)

PRODUCT_PACKAGES += \
	STLauncher

PRODUCT_DEXPREOPT_SPEED_APPS += \
	STLauncher

else

PRODUCT_PACKAGES += \
	Launcher3QuickStepGo

PRODUCT_DEXPREOPT_SPEED_APPS += \
	Launcher3QuickStepGo

PRODUCT_PACKAGES += \
	OneTimeInitializer \
	Browser2

ifeq ($(BOARD_OPTION),empty)

PRODUCT_PACKAGES += \
	Gallery2 \
	MusicFX \
	Music

endif
endif

# Wallpaper
ifneq ($(BOARD_OPTION),empty)

ifneq ($(BOARD_DISPLAY_PANEL),mb1166)
PRODUCT_COPY_FILES += \
	device/stm/stm32mp1/$(BOARD_NAME)/wallpaper/st_background_1280x720.bmp:$(TARGET_COPY_OUT_PRODUCT)/media/wallpaper/wallpaper.bmp
else
PRODUCT_COPY_FILES += \
	device/stm/stm32mp1/$(BOARD_NAME)/wallpaper/st_background_800x480.bmp:$(TARGET_COPY_OUT_PRODUCT)/media/wallpaper/wallpaper.bmp
endif

PRODUCT_PRODUCT_PROPERTIES += \
	ro.config.wallpaper=/product/media/wallpaper/wallpaper.bmp

endif

# ST applications
ifneq ($(BOARD_OPTION),empty)

PRODUCT_PACKAGES += \
	STVideo \
	STCamera \
	STAudio \
	STGraphics

# ST applications compiled with the speed compiler filter
PRODUCT_DEXPREOPT_SPEED_APPS += \
	STVideo \
	STCamera \
	STAudio \
	STGraphics

# ST Copro firmwares
PRODUCT_COPY_FILES += \
	vendor/stm/app/firmwares/$(BOARD_NAME)/copro_m4example.elf:$(TARGET_COPY_OUT_VENDOR)/firmware/copro/copro_m4example.elf

# ST Copro applications
PRODUCT_PACKAGES += \
	STCoproM4Example

ifeq ($(BOARD_OPTION),normal)
PRODUCT_COPY_FILES += \
	vendor/stm/app/firmwares/$(BOARD_NAME)/OpenAMP_TTY_echo.elf:$(TARGET_COPY_OUT_VENDOR)/firmware/copro/OpenAMP_TTY_echo.elf

PRODUCT_PACKAGES += \
	STCoproM4Echo
endif

# Integrate STPerf only in debug build (need permissive)
ifneq ($(TARGET_BUILD_VARIANT),user)

PRODUCT_PACKAGES += \
	STPerf

# ST applications compiled with the speed compiler filter
PRODUCT_DEXPREOPT_SPEED_APPS += \
	STPerf

endif

endif

# STM32 image wrapper. Useful for GDB/OpenOCD (debug)
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_HOST_PACKAGES += \
	stm32wrapper4dbg
endif

PRODUCT_PACKAGES += \
    netutils-wrapper-1.0

#SDK
ifneq ($(filter sdk win_sdk sdk_addon,$(MAKECMDGOALS)),)

# Generate SDK only in Eng build variant
ifeq ($(TARGET_BUILD_VARIANT),eng)
PRODUCT_PACKAGES += \
	EmulatorSmokeTests \
	LeanbackSampleApp \
	SdkSetup

-include sdk/build/product_sdk.mk
-include development/build/product_sdk.mk
else
$(error Eng build variant must be set to generate SDK. Current build variant is $(TARGET_BUILD_VARIANT), please use lunch command to select eng build variant.)
endif

endif
