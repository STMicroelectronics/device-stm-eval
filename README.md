# stm32mp1-eval #

This module contains the STMicroelectronics configuration for Android used to generate images adapted to the STM32MP15 Evaluation boards.

It is part of the STMicroelectronics delivery for Android (see the [delivery][] for more information).

[delivery]: https://wiki.st.com/stm32mpu/wiki/STM32MP15_distribution_for_Android_release_note_-_v1.0.0

The STM32MP15 Evaluation boards integrate a STMicroelectronics STM32MP1 chip.

See the associated wiki page for more details on STMicrolectronics site.

## Description ##

This module version is the first version for STM32MP1

Please see the Android delivery release notes for more details.

## Documentation ##

* The [release notes][] document the information on the release.
* The [distribution package][] provides detailed information on how to use this delivery.

[release notes]: https://wiki.st.com/stm32mpu/wiki/STM32MP15_distribution_for_Android_release_note_-_v1.0.0
[distribution package]: https://wiki.st.com/stm32mpu/wiki/STM32MP1_Distribution_Package_for_Android

## Dependencies ##

This module can't be used alone. It is part of the STMicroelectronics delivery for Android.

## Containing ##

This module contains several files and directories.

**Product profiles:**
* `boardsetup.sh`: list supported product profiles for this board device

**Makefiles:**
* `AndroidBoard.mk`: include kernel makefile
* `Android.bp` and `Android.mk`: used for sub-directories makefiles
* `AndroidProduct.mk`: used to define available products
* `aosp_eval.mk`: specific product configuration (include different makefiles depending on product configuration)
* `device.mk`: generic product configuration
* `BoardConfig.mk`: required board configuration

**Init:**
* `init.stm.rc`: specific STM32MP1 init commands
* `init.stm.sh`: scripts executed to load required modules
* `init.stm.network.rc`: network init commands (mainly wpa_supplicant)
* `init.stm.usb.rc`: usb init commands
* `init.stm.security.rc`: tee init commands

**File System:**
* `fstab_sd.stm`: sd card based file system configuration file
* `fstab_emmc.stm`: eMMC key based file system configuration file

**Peripherals:**
* `./peripheral/dumpstate`: specific board information dump configuration

**Configuration:**
* `./firmware/*`: required or optional firmwares (ex: Wi-Fi/BT firmwares)
* `./lights/*`: lights configuration files
* `./media/*`: audio and video configuration files (audio policy, audio HAL configuration...)
* `./network/*`: network configuration files (bluetooth and Wi-Fi)
* `./thermal/*`: thermal configuration files

**Overlay Configuration:**
* `./overlay`: contains Android frameworks configuration overlay

**Sepolicy**
* `./sepolicy`: sepolicy for STM32MP15 Evaluation boards

**Others:**
* `board-info.txt`: STM32MP15 Evaluation boards info
* `st_core_hardware.xml`: define permissions for STM32MP15 Evaluation boards
* `manifest.xml`: define vendor interfaces for STM32MP15 Evaluation boards
* `compatibility_matrix.xml`: define vendor required services
* `system.prop`: define device system properties (set at init)
* `ueventd.stm.rc`: define kernel device access rights
* `wallpaper/*`: default wallpaper bitmap

## License ##

This module is distributed under the Apache License, Version 2.0 found in the [LICENSE](./LICENSE) file.
