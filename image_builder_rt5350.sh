#!/bin/bash

USB="kmod-usb-core kmod-usb2 kmod-usb-ohci"

FIREWALL="firewall iptables"

PPP="$USB ppp ppp-mod-pppoe kmod-ppp kmod-pppoe kmod-pppox"

SSH="dropbear"

WIFI="kmod-cfg80211 kmod-mac80211 kmod-rt2800-lib kmod-rt2800-pci kmod-rt2x00-lib kmod-rt2x00-pci kmod-rt2x00-soc iw wpad-mini"

GARGOYLE="gargoyle libericstools httpd-gargoyle haserl-i18n plugin-gargoyle-i18n-English-EN  webmon-gargoyle plugin-gargoyle-initd gargoyle-firewall-util"
#gargoyle-mjpg-streamer
#plugin-gargoyle-logread
#plugin-gargoyle-minidlna
#plugin-gargoyle-pptp
#plugin-gargoyle-usb-printer 
#plugin-gargoyle-usb-storage 
#plugin-gargoyle-webcam 
#plugin-gargoyle-webshell 
#plugin-gargoyle-wifi-schedule 
#qos-gargoyle 


LUCI="luci"

XWRT="webif"

USB_SOUND="$USB kmod-usb-audio kmod-sound-core"

MASS_STORAGE="$USB kmod-usb-storage kmod-usb-storage-extras block-mount e2fsprogs kmod-fs-ext4 kmod-fs-vfat kmod-nls-cp437 kmod-nls-iso8859-1  kmod-nls-utf8"

USB_SERIAL="$USB ser2net serialoverip kmod-usb-serial kmod-usb-serial-ch341 kmod-usb-serial-cp210x kmod-usb-serial-ftdi kmod-usb-serial-pl2303 kmod-usb-acm"

WEBCAM="$USB kmod-i2c-core mjpg-streamer kmod-video-core kmod-video-cpia2 kmod-video-gspca-conex kmod-video-gspca-core kmod-video-gspca-etoms kmod-video-gspca-finepix kmod-video-gspca-gl860 kmod-video-gspca-jeilinj kmod-video-gspca-konica kmod-video-gspca-m5602 kmod-video-gspca-mars kmod-video-gspca-mr97310a kmod-video-gspca-ov519 kmod-video-gspca-ov534 kmod-video-gspca-ov534-9 kmod-video-gspca-pac207 kmod-video-gspca-pac7311 kmod-video-gspca-se401 kmod-video-gspca-sn9c20x kmod-video-gspca-sonixb kmod-video-gspca-sonixj kmod-video-gspca-spca500 kmod-video-gspca-spca501 kmod-video-gspca-spca505 kmod-video-gspca-spca506 kmod-video-gspca-spca508 kmod-video-gspca-spca561 kmod-video-gspca-sq905 kmod-video-gspca-sq905c kmod-video-gspca-stk014 kmod-video-gspca-stv06xx kmod-video-gspca-sunplus kmod-video-gspca-t613 kmod-video-gspca-tv8532 kmod-video-gspca-vc032x kmod-video-gspca-zc3xx kmod-video-pwc kmod-video-sn9c102 kmod-video-uvc kmod-video-videobuf2"

INTERNET_RADIO="$USB_SOUND mpd-mini mpc alsa-utils"

AUDIO_STREAMER="$USB_SOUND  darkice  lame alsa-utils "
#icecast

DLNA="minidlna"

MQTT="libmosquitto libmosquitto-nossl mosquitto mosquitto-client mosquitto-nossl"

GPIO="gpioctl-sysfs kmod-pwm-gpio libugpio kmod-gpio-button-hotplug kmod-input-gpio-encoder kmod-input-gpio-keys kmod-input-gpio-keys-polled kmod-leds-gpio kmod-ledtrig-gpio"

I2C="i2c-tools kmod-i2c-core kmod-i2c-gpio kmod-i2c-gpio-custom libi2c kmod-i2c-algo-bit kmod-i2c-algo-pca kmod-i2c-algo-pcf kmod-i2c-mux kmod-i2c-mux-gpio kmod-i2c-mux-pca9541 kmod-i2c-mux-pca954x kmod-i2c-tiny-usb"

DEFAULT_EXCLUDED="-dnsmasq -dropbear -firewall -iptables -kmod-ipt-core -opkg -ppp -ppp-mod-pppoe"
WIFI_EXCLUDED="-kmod-rt2800-pci -wpad-mini"

case "$1" in
default)
    PACKAGES=""
    ;;
mini)
    PACKAGES=" $DEFAULT_EXCLUDED $WIFI_EXCLUDED"
    ;;
mini_luci_web)
    PACKAGES="$LUCI $DEFAULT_EXCLUDED $WIFI_EXCLUDED"
    ;;
mini_luci_web_wifi)
    PACKAGES="opkg $LUCI $MASS_STORAGE $WIFI"
#   PACKAGES="$LUCI $DEFAULT_EXCLUDED $WIFI"
    ;;
mini_gargoyle_web)
    PACKAGES="$GARGOYLE  $DEFAULT_EXCLUDED $WIFI_EXCLUDED"
    ;;
serial_server)
    PACKAGES="$USB_SERIAL $DEFAULT_EXCLUDED $WIFI_EXCLUDED"
    ;;
mqtt_server)
    PACKAGES="$MQTT $I2C $GPIO $USB_SERIAL $DEFAULT_EXCLUDED $WIFI_EXCLUDED"
    ;;
dlna_server)
    PACKAGES="$DLNA $MASS_STORAGE $DEFAULT_EXCLUDED $WIFI_EXCLUDED"
    ;;
video_streamer)
    PACKAGES="$WEBCAM $DEFAULT_EXCLUDED $WIFI_EXCLUDED"
    ;;
audio_streamer)
    PACKAGES="$AUDIO_STREAMER $DEFAULT_EXCLUDED $WIFI_EXCLUDED"
    ;;
internet_radio)
    PACKAGES="$INTERNET_RADIO $DEFAULT_EXCLUDED $WIFI_EXCLUDED"
    ;;
*)
    echo ""
    echo "Parameter error"
    echo "Usage image_builder_rt5350.sh <profile_name>"
    echo ""
    exit
    ;;
esac

echo ""
echo "Buildning image for profile $1"
echo "Additional packages: $PACKAGES"
echo ""

#cleanup
rm -fdr files/target/*

#copy common base
cp -rf files/common/* files/target

#copy/ovveride target specific files
cp -rf files/$1/* files/target

make image PROFILE="MPR_A1"  IGNORE_ERRORS=1 PACKAGES="$PACKAGES" FILES=files/target
mv -f bin/ramips/openwrt-ramips-rt305x-mpr-a1-squashfs-sysupgrade.bin bin/ramips/$1.bin

#dnsmasq
#opkg
