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

PRODUCT_CHARACTERISTICS := nosdcard
PRODUCT_SHIPPING_API_LEVEL = 28

BOARD_USES_TINYHAL_AUDIO := true
USE_XML_AUDIO_POLICY_CONF := 1

# Setting Overlay
DEVICE_PACKAGE_OVERLAYS := device/stm/stm32mp1/$(BOARD_NAME)/overlay

# Build and run only ART
PRODUCT_RUNTIMES := runtime_libart_default

# Set this value here as BoardConfig.mk is parsed later
BOARD_WLAN_INTERFACE := wlan0

# Use legacy OMX Interface for now
persist.media.treble_omx=false

#-- Android HALs --
TARGET_BOOTCTRL_HAL := stm
TARGET_USBAUDIO_HAL := default
TARGET_PRIMARYAUDIO_HAL := stm
TARGET_USBCAM_HAL := stm
TARGET_LIGHTS_HAL := stm
TARGET_GRALLOC_HAL := stm
TARGET_COMPOSER_HAL := drm_stm32mp1
TARGET_COPRO_HAL := stm
TARGET_MEMTRACK_HAL := stm
TARGET_REMOTESUBMIX_AUDIO_HAL := default
TARGET_DEFAULTUSBCAM_HAL := default
TARGET_POWER_HAL := default

PRODUCT_PACKAGES += \
	watchdogd

# BOOT CONTROL HAL package
PRODUCT_PACKAGES += \
	bootctrl.$(TARGET_BOOTCTRL_HAL)

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
	copro.$(TARGET_COPRO_HAL) \
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

# LIGHTS HAL module
PRODUCT_PACKAGES += \
	liblightsconfig \
	lights.$(TARGET_LIGHTS_HAL)

# LIGHTS TEST application (only for userdebug and eng)
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
	lights-hal-example-app
endif

# WIFI HAL
PRODUCT_PACKAGES += \
	libwifi-hal-stm

# GRALLOC HAL module
PRODUCT_PACKAGES += \
	libdrm \
	libdrm_vivante \
	hwcomposer.$(TARGET_COMPOSER_HAL) \
	gralloc.$(TARGET_GRALLOC_HAL) \
	libGLESv2_VIVANTE \
	libEGL_VIVANTE \
	libGLESv1_CM_VIVANTE \
	libGAL \
	libGLSLC \
	libVSC

PRODUCT_PROPERTY_OVERRIDES += \
	ro.hardware.gralloc=$(TARGET_GRALLOC_HAL) \
	ro.hardware.audio.primary=$(TARGET_PRIMARYAUDIO_HAL) \
	ro.hardware.bootctrl=$(TARGET_BOOTCTRL_HAL) \
	ro.hardware.audio.usb=$(TARGET_USBAUDIO_HAL) \
	ro.hardware.memtrack=$(TARGET_MEMTRACK_HAL) \
	ro.hardware.power=$(TARGET_POWER_HAL) \
	ro.hardware.hwcomposer=$(TARGET_COMPOSER_HAL) \
	ro.hardware.lights=$(TARGET_LIGHTS_HAL) \

# Init
PRODUCT_COPY_FILES += \
	device/stm/stm32mp1-kernel/prebuilt/kernel-$(SOC_VERSION):kernel \
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

# Add default wallpaper
PRODUCT_COPY_FILES += \
	device/stm/stm32mp1/$(BOARD_NAME)/wallpaper/st_background_1280x720.bmp:data/wallpaper.bmp

PRODUCT_PROPERTY_OVERRIDES += \
	ro.config.wallpaper=/data/wallpaper.bmp

# fstab
PRODUCT_COPY_FILES += device/stm/stm32mp1/$(BOARD_NAME)/fstab_$(BOARD_DISK_TYPE).stm:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.stm

# Wireless configuration
PRODUCT_COPY_FILES += \
	device/stm/stm32mp1/$(BOARD_NAME)/network/wifi/wpa_supplicant.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant.conf \
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
	device/stm/stm32mp1/$(BOARD_NAME)/media/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles.xml \
	device/stm/stm32mp1/$(BOARD_NAME)/media/video/media_codecs_google_video_limited.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video_limited.xml \
	frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
	frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml

# Media seccomp policy file
PRODUCT_COPY_FILES += \
	device/stm/stm32mp1/$(BOARD_NAME)/media/mediacodec.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy

# Graphics hardware service
PRODUCT_PACKAGES += \
	android.hardware.graphics.allocator@2.0-service \
	android.hardware.graphics.allocator@2.0-impl \
	android.hardware.graphics.mapper@2.0-impl \
	android.hardware.graphics.composer@2.1-impl \
	android.hardware.graphics.composer@2.1-service \
	android.hardware.configstore@1.0-impl \
	android.hardware.configstore@1.0-service

# Boot hardware service
PRODUCT_PACKAGES += \
	android.hardware.boot@1.0-impl

# Lights hardware service
PRODUCT_PACKAGES += \
	android.hardware.light@2.0-service \
	android.hardware.light@2.0-impl

# Dumpstate hardware service
PRODUCT_PACKAGES += \
	android.hardware.dumpstate@1.0-service.$(BOARD_NAME)

# Keymaster hardware service
PRODUCT_PACKAGES += \
	android.hardware.keymaster@3.0-service \
	android.hardware.keymaster@3.0-impl

# Audio hardware service
PRODUCT_PACKAGES += \
	android.hardware.audio@2.0-service \
	android.hardware.audio@4.0-impl \
	android.hardware.audio.effect@4.0-impl \
	android.hardware.soundtrigger@2.1-impl \
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
	libthermalconfig \
	android.hardware.thermal@1.1-service.stm32mp1

# Power hardware service
PRODUCT_PACKAGES += \
	power.$(TARGET_POWER_HAL) \
	android.hardware.power@1.0-impl \
	android.hardware.power@1.0-service

# Memtrack hardware service
PRODUCT_PACKAGES += \
	memtrack.$(TARGET_MEMTRACK_HAL) \
	android.hardware.memtrack@1.0-service \
	android.hardware.memtrack@1.0-impl

# Bootctrl service
PRODUCT_PACKAGES += \
	android.hardware.boot@1.0-service \
	android.hardware.boot@1.0-impl

# Health hardware service
PRODUCT_PACKAGES += \
	android.hardware.health@2.0-service.stm32mp1

# TEE hardware service
PRODUCT_PACKAGES += \
	tee-supplicant \
	libteec

# TEE tests
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
	xtest

PRODUCT_COPY_FILES += \
	device/stm/stm32mp1-tee/prebuilt/$(BOARD_NAME)/ta/e626662e-c0e2-485c-b8c8-09fbce6edf3d.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/e626662e-c0e2-485c-b8c8-09fbce6edf3d.ta \
	device/stm/stm32mp1-tee/prebuilt/$(BOARD_NAME)/ta/e13010e0-2ae1-11e5-896a-0002a5d5c51b.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/e13010e0-2ae1-11e5-896a-0002a5d5c51b.ta \
	device/stm/stm32mp1-tee/prebuilt/$(BOARD_NAME)/ta/5ce0c432-0ab0-40e5-a056-782ca0e6aba2.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/5ce0c432-0ab0-40e5-a056-782ca0e6aba2.ta \
	device/stm/stm32mp1-tee/prebuilt/$(BOARD_NAME)/ta/c3f6e2c0-3548-11e1-b86c-0800200c9a66.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/c3f6e2c0-3548-11e1-b86c-0800200c9a66.ta \
	device/stm/stm32mp1-tee/prebuilt/$(BOARD_NAME)/ta/cb3e5ba0-adf1-11e0-998b-0002a5d5c51b.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/cb3e5ba0-adf1-11e0-998b-0002a5d5c51b.ta \
	device/stm/stm32mp1-tee/prebuilt/$(BOARD_NAME)/ta/ffd2bded-ab7d-4988-95ee-e4962fff7154.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/ffd2bded-ab7d-4988-95ee-e4962fff7154.ta \
	device/stm/stm32mp1-tee/prebuilt/$(BOARD_NAME)/ta/5b9e0e40-2636-11e1-ad9e-0002a5d5c51b.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/5b9e0e40-2636-11e1-ad9e-0002a5d5c51b.ta \
	device/stm/stm32mp1-tee/prebuilt/$(BOARD_NAME)/ta/12345678-5b69-11e4-9dbb-101f74f00099.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/12345678-5b69-11e4-9dbb-101f74f00099.ta \
	device/stm/stm32mp1-tee/prebuilt/$(BOARD_NAME)/ta/614789f2-39c0-4ebf-b235-92b32ac107ed.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/614789f2-39c0-4ebf-b235-92b32ac107ed.ta \
	device/stm/stm32mp1-tee/prebuilt/$(BOARD_NAME)/ta/e6a33ed4-562b-463a-bb7e-ff5e15a493c8.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/e6a33ed4-562b-463a-bb7e-ff5e15a493c8.ta \
	device/stm/stm32mp1-tee/prebuilt/$(BOARD_NAME)/ta/873bcd08-c2c3-11e6-a937-d0bf9c45c61c.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/873bcd08-c2c3-11e6-a937-d0bf9c45c61c.ta \
	device/stm/stm32mp1-tee/prebuilt/$(BOARD_NAME)/ta/b689f2a7-8adf-477a-9f99-32e90c0ad0a2.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/b689f2a7-8adf-477a-9f99-32e90c0ad0a2.ta \
	device/stm/stm32mp1-tee/prebuilt/$(BOARD_NAME)/ta/731e279e-aafb-4575-a771-38caa6f0cca6.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/731e279e-aafb-4575-a771-38caa6f0cca6.ta \
	device/stm/stm32mp1-tee/prebuilt/$(BOARD_NAME)/ta/d17f73a0-36ef-11e1-984a-0002a5d5c51b.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/d17f73a0-36ef-11e1-984a-0002a5d5c51b.ta \
	device/stm/stm32mp1-tee/prebuilt/$(BOARD_NAME)/ta/f157cda0-550c-11e5-a6fa-0002a5d5c51b.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/f157cda0-550c-11e5-a6fa-0002a5d5c51b.ta
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
	frameworks/native/data/etc/android.hardware.screen.landscape.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.screen.landscape.xml \
	frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml

# Need AppWidget permission to prevent from Launcher's crash.
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.software.app_widgets.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.app_widgets.xml

# Lights configuration
PRODUCT_COPY_FILES += \
	device/stm/stm32mp1/$(BOARD_NAME)/lights/lights.stm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/lights.$(BOARD_NAME).xml

# Thermal configuration
PRODUCT_COPY_FILES += \
	device/stm/stm32mp1/$(BOARD_NAME)/thermal/thermal.stm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/thermal.$(BOARD_NAME).xml

# Network
PRODUCT_PACKAGES += \
	libwpa_client \
	hostapd \
	wpa_supplicant

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

PRODUCT_STATIC_BOOT_CONTROL_HAL := \
	bootctrl_static.$(TARGET_BOOTCTRL_HAL) \
	libcutils \
	libz

PRODUCT_PACKAGES += \
	update_engine_sideload

# Set product properties

# Allows healthd to boot directly from charger mode rather than initiating a reboot.
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
	ro.enable_boot_charger_mode=1

# Wi-Fi netlink socket interface = wlan0
# Bluetooth hci socket interface = hci0
PRODUCT_PROPERTY_OVERRIDES += \
	persist.wifi.offload.enable=false

# OpenGLES version = 2.0 (0x00020000 = 131072)
# Recommended LCD density = 240
PRODUCT_PROPERTY_OVERRIDES += \
	ro.opengles.version=131072 \
	ro.sf.lcd_density=240

# HWC disable overlay planes usage
PRODUCT_PROPERTY_OVERRIDES += \
	hwc.drm.use_overlay_planes=0

# USB ADB configuration
ifeq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PROPERTY_OVERRIDES += \
	ro.adb.secure=1
endif

PRODUCT_PROPERTY_OVERRIDES +=  \
	persist.sys.usb.config=adb

# for off charging mode
PRODUCT_PACKAGES += \
	charger_res_images

# for init property extract
PRODUCT_PACKAGES += \
	initprop

# for systrace
# PRODUCT_PROPERTY_OVERRIDES += debug.atrace.tags.enableflags=802922

PRODUCT_PACKAGES += \
	vmlinux \
	stagefright \
	libaudiopolicymanagerdefault \
	libaudiopolicymanager

PRODUCT_PROPERTY_OVERRIDES += \
	ro.radio.noril=yes \
	config.disable_vrmanager=true \
	config.disable_consumerir=true

ifneq ($(BOARD_OPTION),empty)

# ST base applications
PRODUCT_PACKAGES += \
	STVideo \
	STPerf \
	STCamera

# ST Copro firmwares
PRODUCT_COPY_FILES += \
	vendor/stm/app/firmwares/$(BOARD_NAME)/OpenAMP_TTY_echo.elf:$(TARGET_COPY_OUT_VENDOR)/firmware/copro/OpenAMP_TTY_echo.elf \
	vendor/stm/app/firmwares/$(BOARD_NAME)/copro_m4example.elf:$(TARGET_COPY_OUT_VENDOR)/firmware/copro/copro_m4example.elf

# ST Copro applications
PRODUCT_PACKAGES += \
	STCoproM4Echo \
	STCoproM4Example

PRODUCT_DEXPREOPT_SPEED_APPS += \
	SystemUI \
	Settings \
	STVideo \
	STPerf \
	STCamera

else

PRODUCT_DEXPREOPT_SPEED_APPS += \
	SystemUI \
	Settings

endif

PRODUCT_PACKAGES += \
	Launcher3Go

PRODUCT_DEXPREOPT_SPEED_APPS += \
	Launcher3Go

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
