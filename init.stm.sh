#!/vendor/bin/sh

# echo "BootAnalyze: load usb snd start">>/dev/kmsg
insmod /vendor/lib/modules/snd-usbmidi-lib.ko
insmod /vendor/lib/modules/snd-hwdep.ko
insmod /vendor/lib/modules/snd-usb-audio.ko
# echo "BootAnalyze: load usb snd end">>/dev/kmsg

# echo "BootAnalyze: Touchscreen driver start (MB1230 and MB1166 options)">>/dev/kmsg
insmod /vendor/lib/modules/goodix.ko
insmod /vendor/lib/modules/edt-ft5x06.ko
# echo "BootAnalyze: Touchscreen driver end">>/dev/kmsg

# echo "BootAnalyze: Realtek dongle driver start">>/dev/kmsg
insmod /vendor/lib/modules/rtl8xxxu.ko
# echo "BootAnalyze: Realtek dongle driver end">>/dev/kmsg

# echo "BootAnalyze: TP-Link HTC TL WN722N Wi-Fi dongle driver start">>/dev/kmsg
insmod /vendor/lib/modules/ath.ko
insmod /vendor/lib/modules/ath9k_hw.ko
insmod /vendor/lib/modules/ath9k_common.ko
insmod /vendor/lib/modules/ath9k.ko
insmod /vendor/lib/modules/ath9k_htc.ko
# echo "BootAnalyze: TP-Link HTC TL WN722N Wi-Fi dongle driver end">>/dev/kmsg

# echo "BootAnalyze: DCMI camera driver start">>/dev/kmsg
insmod /vendor/lib/modules/videobuf2-dma-contig.ko
insmod /vendor/lib/modules/v4l2-fwnode.ko
insmod /vendor/lib/modules/ov5640.ko
insmod /vendor/lib/modules/stm32-dcmi.ko
# echo "BootAnalyze: DCMI camera driver end">>/dev/kmsg

setprop vendor.modules.ready 1
