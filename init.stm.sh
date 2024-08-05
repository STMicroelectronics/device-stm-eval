#!/vendor/bin/sh

# echo "BootAnalyze: load crypto start">>/dev/kmsg
insmod /vendor/lib/modules/sha3_generic.ko
# echo "BootAnalyze: load crypto end">>/dev/kmsg

# echo "BootAnalyze: load audio start">>/dev/kmsg
insmod /vendor/lib/modules/snd-soc-simple-card-utils.ko
insmod /vendor/lib/modules/snd-soc-audio-graph-card.ko
insmod /vendor/lib/modules/snd-soc-hdmi-codec.ko
insmod /vendor/lib/modules/snd-soc-spdif-rx.ko
insmod /vendor/lib/modules/snd-soc-spdif-tx.ko
insmod /vendor/lib/modules/snd-soc-stm32-i2s.ko
insmod /vendor/lib/modules/snd-soc-stm32-sai-sub.ko
insmod /vendor/lib/modules/snd-soc-stm32-sai.ko
insmod /vendor/lib/modules/snd-soc-stm32-spdifrx.ko
insmod /vendor/lib/modules/snd-soc-wm-hubs.ko
insmod /vendor/lib/modules/snd-soc-wm8994.ko
insmod /vendor/lib/modules/wm8994.ko
# echo "BootAnalyze: load audio end">>/dev/kmsg

# echo "BootAnalyze: GKI net driver start">>/dev/kmsg
insmod /vendor/lib/modules/libarc4.ko
insmod /vendor/lib/modules/rfkill.ko
insmod /vendor/lib/modules/cfg80211.ko
insmod /vendor/lib/modules/mac80211.ko
# echo "BootAnalyze: GKI net driver end">>/dev/kmsg

# echo "BootAnalyze: load 6lowpan network start">>/dev/kmsg
insmod /vendor/lib/modules/6lowpan.ko
insmod /vendor/lib/modules/nhc_dest.ko
insmod /vendor/lib/modules/nhc_fragment.ko
insmod /vendor/lib/modules/nhc_hop.ko
insmod /vendor/lib/modules/nhc_ipv6.ko
insmod /vendor/lib/modules/nhc_mobility.ko
insmod /vendor/lib/modules/nhc_routing.ko
insmod /vendor/lib/modules/nhc_udp.ko
# echo "BootAnalyze: load 6lowpan network end">>/dev/kmsg

# echo "BootAnalyze: load ieee802154 network start">>/dev/kmsg
insmod /vendor/lib/modules/ieee802154.ko
insmod /vendor/lib/modules/ieee802154_6lowpan.ko
insmod /vendor/lib/modules/ieee802154_socket.ko
insmod /vendor/lib/modules/mac802154.ko
# echo "BootAnalyze: load ieee802154 network end">>/dev/kmsg

# echo "BootAnalyze: load nfc start">>/dev/kmsg
# insmod /vendor/lib/modules/nfc.ko
# echo "BootAnalyze: load nfc end">>/dev/kmsg

# echo "BootAnalyze: load can start">>/dev/kmsg
# insmod /vendor/lib/modules/can.ko
# insmod /vendor/lib/modules/can-raw.ko
# insmod /vendor/lib/modules/can-bcm.ko
# insmod /vendor/lib/modules/can-gw.ko
# insmod /vendor/lib/modules/can-dev.ko
# insmod /vendor/lib/modules/vcan.ko
# insmod /vendor/lib/modules/slcan.ko
# echo "BootAnalyze: load can end">>/dev/kmsg

# echo "BootAnalyze: load ppp start">>/dev/kmsg
insmod /vendor/lib/modules/slhc.ko
insmod /vendor/lib/modules/ppp_generic.ko
insmod /vendor/lib/modules/bsd_comp.ko
insmod /vendor/lib/modules/ppp_deflate.ko
insmod /vendor/lib/modules/ppp_mppe.ko
insmod /vendor/lib/modules/pppox.ko
insmod /vendor/lib/modules/pptp.ko
# echo "BootAnalyze: load ppp end">>/dev/kmsg

# echo "BootAnalyze: load network protocol start">>/dev/kmsg
insmod /vendor/lib/modules/8021q.ko
insmod /vendor/lib/modules/l2tp_core.ko
insmod /vendor/lib/modules/l2tp_ppp.ko
insmod /vendor/lib/modules/tipc.ko
insmod /vendor/lib/modules/diag.ko
# echo "BootAnalyze: load network protocol start">>/dev/kmsg

# echo "BootAnalyze: load Bluetooth start">>/dev/kmsg
# insmod /vendor/lib/modules/bluetooth.ko
# insmod /vendor/lib/modules/btsdio.ko
# insmod /vendor/lib/modules/btbcm.ko
# insmod /vendor/lib/modules/btqca.ko
# insmod /vendor/lib/modules/rfcomm.ko
# insmod /vendor/lib/modules/hidp.ko
# insmod /vendor/lib/modules/hci_uart.ko
# echo "BootAnalyze: load Bluetooth end">>/dev/kmsg

# echo "BootAnalyze: load USB serial start">>/dev/kmsg
insmod /vendor/lib/modules/usbserial.ko
insmod /vendor/lib/modules/ftdi_sio.ko
# echo "BootAnalyze: load USB serial end">>/dev/kmsg

# echo "BootAnalyze: load USB Communication Device Class start">>/dev/kmsg
insmod /vendor/lib/modules/usbnet.ko
insmod /vendor/lib/modules/cdc_ether.ko
insmod /vendor/lib/modules/cdc_eem.ko
insmod /vendor/lib/modules/cdc_ncm.ko
insmod /vendor/lib/modules/cdc-acm.ko
# echo "BootAnalyze: load USB Communication Device Class end">>/dev/kmsg

# echo "BootAnalyze: load USB Ethernet devices start">>/dev/kmsg
insmod /vendor/lib/modules/smsc75xx.ko
insmod /vendor/lib/modules/smsc95xx.ko
insmod /vendor/lib/modules/rtl8150.ko
insmod /vendor/lib/modules/r8152.ko
insmod /vendor/lib/modules/ax88179_178a.ko
insmod /vendor/lib/modules/aqc111.ko
insmod /vendor/lib/modules/r8153_ecm.ko
# echo "BootAnalyze: load USB Ethernet devices end">>/dev/kmsg

# echo "BootAnalyze: load leds start">>/dev/kmsg
insmod /vendor/lib/modules/leds-gpio.ko
insmod /vendor/lib/modules/leds-pwm.ko
# echo "BootAnalyze: load leds end">>/dev/kmsg

# echo "BootAnalyze: load timers start">>/dev/kmsg
insmod /vendor/lib/modules/counter.ko
insmod /vendor/lib/modules/stm32-lptimer.ko
insmod /vendor/lib/modules/stm32-lptimer-cnt.ko
insmod /vendor/lib/modules/stm32-lptimer-trigger.ko
insmod /vendor/lib/modules/stm32-timer-cnt.ko
insmod /vendor/lib/modules/stm32-timer-trigger.ko
insmod /vendor/lib/modules/stm32-timers.ko
# echo "BootAnalyze: load timers end">>/dev/kmsg

# echo "BootAnalyze: load ethernet start">>/dev/kmsg
insmod /vendor/lib/modules/smsc.ko
insmod /vendor/lib/modules/stmmac-platform.ko
insmod /vendor/lib/modules/dwmac-generic.ko
insmod /vendor/lib/modules/dwmac-stm32.ko
insmod /vendor/lib/modules/dwmac-ipq806x.ko
insmod /vendor/lib/modules/dwmac-qcom-ethqos.ko
insmod /vendor/lib/modules/dwmac-sun8i.ko
insmod /vendor/lib/modules/dwmac-sunxi.ko
# echo "BootAnalyze: load ethernet end">>/dev/kmsg

# echo "BootAnalyze: Touchscreen driver start">>/dev/kmsg
insmod /vendor/lib/modules/edt-ft5x06.ko
insmod /vendor/lib/modules/ili210x.ko
# echo "BootAnalyze: Touchscreen driver end">>/dev/kmsg

# echo "BootAnalyze: Realtek dongle driver start">>/dev/kmsg
insmod /vendor/lib/modules/rtl8xxxu.ko
# echo "BootAnalyze: Realtek dongle driver end">>/dev/kmsg

# echo "BootAnalyze: Mediatek dongle driver start">>/dev/kmsg
insmod /vendor/lib/modules/mt76.ko
insmod /vendor/lib/modules/mt76-usb.ko
insmod /vendor/lib/modules/mt76x02-lib.ko
insmod /vendor/lib/modules/mt76x02-usb.ko
insmod /vendor/lib/modules/mt76x2-common.ko
insmod /vendor/lib/modules/mt76x2u.ko
# echo "BootAnalyze: Mediatek dongle driver end">>/dev/kmsg

# echo "BootAnalyze: TP-Link HTC TL WN722N Wi-Fi dongle driver start">>/dev/kmsg
insmod /vendor/lib/modules/ath.ko
insmod /vendor/lib/modules/ath9k_hw.ko
insmod /vendor/lib/modules/ath9k_common.ko
insmod /vendor/lib/modules/ath9k.ko
insmod /vendor/lib/modules/ath9k_htc.ko
# echo "BootAnalyze: TP-Link HTC TL WN722N Wi-Fi dongle driver end">>/dev/kmsg

# echo "BootAnalyze: Broadcom Wi-Fi dongle driver start">>/dev/kmsg
# insmod /vendor/lib/modules/brcmfmac.ko
# insmod /vendor/lib/modules/brcmutil.ko
# echo "BootAnalyze: Broadcom Wi-Fi dongle driver end">>/dev/kmsg

# echo "BootAnalyze: DCMI camera driver start">>/dev/kmsg
insmod /vendor/lib/modules/v4l2-h264.ko
insmod /vendor/lib/modules/v4l2-vp9.ko
insmod /vendor/lib/modules/hantro-vpu.ko
insmod /vendor/lib/modules/ov5640.ko
insmod /vendor/lib/modules/ov5645.ko
insmod /vendor/lib/modules/imx335.ko
insmod /vendor/lib/modules/stm32-csi2host.ko
insmod /vendor/lib/modules/stm32-dcmi.ko
insmod /vendor/lib/modules/stm32-dcmipp.ko
# echo "BootAnalyze: DCMI camera driver end">>/dev/kmsg

# echo "BootAnalyze: DFSDM driver start">>/dev/kmsg
insmod /vendor/lib/modules/kfifo_buf.ko
insmod /vendor/lib/modules/industrialio-triggered-buffer.ko
# echo "BootAnalyze: DFSDM driver end">>/dev/kmsg

# echo "BootAnalyze: ADC driver start">>/dev/kmsg
insmod /vendor/lib/modules/stm32-adc-core.ko
insmod /vendor/lib/modules/stm32-adc.ko
# echo "BootAnalyze: ADC driver end">>/dev/kmsg

# echo "BootAnalyze: PWM driver start">>/dev/kmsg
insmod /vendor/lib/modules/pwm-stm32.ko
insmod /vendor/lib/modules/pwm-stm32-lp.ko
# echo "BootAnalyze: PWM driver end">>/dev/kmsg

# echo "BootAnalyze: KHeaders module start">>/dev/kmsg
insmod /vendor/lib/modules/kheaders.ko
# echo "BootAnalyze: KHeaders module end">>/dev/kmsg

setprop vendor.modules.ready 1
