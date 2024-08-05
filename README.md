# stm32mp2-eval #

This module contains the STMicroelectronics configuration for Android used to generate images adapted to the STM32MP2 EVAL board.
It is part of the STMicroelectronics delivery for Android.

The STM32MP2 EVAL board integrates a STMicroelectronics STM32MP2 chip.

See the associated wiki page for more details.

## Description ##

This module version is the updated version for STM32MP25 OpenSTDroid V5.0
Please see the Android delivery release notes for more details.

## Documentation ##

* The [release notes][] document the information on the release.
[release notes]: https://wiki.st.com/stm32mpu/wiki/STM32_MPU_OpenSTDroid_release_note_-_v5.1.0

## Dependencies ##

This module can't be used alone. It is part of the STMicroelectronics delivery for Android.

## Containing ##

This module contains several files and directories.

**Makefiles:**
* `Android.bp` and `Android.mk`: used for sub-directories makefiles
* `AndroidProduct.mk`: used to define available products
* `aosp_eval.mk`: specific product configuration (include different makefiles depending on product configuration)
* `device.mk`: generic product configuration
* `BoardConfig.mk`: required board configuration

**Init:**
* `init.stm.rc`: specific STM32MP2 init commands
* `init.stm.sh`: scripts executed to load required modules
* `init.stm.network.rc`: network init commands (mainly wpa_supplicant)
* `init.stm.usb.rc`: usb init commands
* `init.stm.security.rc`: tee init commands
* `init.stm.camera.rc`: camera init commands

**File System:**
* `fstab_sd.stm`: sd card based file system configuration file
* `fstab_emmc.stm`: eMMC key based file system configuration file
* `fstab_hybrid_avb.stm`: eMMC key based file system configuration file and sd card for user data (test purpose)

**Peripherals:**
* `./hardware/dumpstate`: specific board information dump configuration

**Configuration:**
* `./firmware/*`: required or optional firmwares (ex: Wi-Fi/BT firmwares)
* `./media/*`: audio and video configuration files (audio policy, audio HAL configuration...)
* `./network/*`: network configuration files (bluetooth and Wi-Fi)

**Overlay Configuration:**
* `./overlay`: contains Android frameworks configuration overlay

**Sepolicy**
* `./sepolicy`: sepolicy for STM32MP25 Evaluation boards

**Others**
* several configuration files

## License ##

This module is distributed under the Apache License, Version 2.0 found in the [LICENSE](./LICENSE) file.
