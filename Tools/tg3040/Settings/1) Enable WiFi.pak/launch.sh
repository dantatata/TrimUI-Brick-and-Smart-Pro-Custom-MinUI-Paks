#!/bin/sh
LOG_FILE="./wifi_toggle.log"
PAK_PATH=$(dirname "$0")

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

rename_pak() {
    local new_name=$1
    # Handle all possible current names
    mv "$PAK_PATH" "${PAK_PATH//Toggle WiFi.pak/$new_name}"
    mv "$PAK_PATH" "${PAK_PATH//Enable WiFi.pak/$new_name}"
    mv "$PAK_PATH" "${PAK_PATH//Disable WiFi.pak/$new_name}"
}

# Check if wlan0 is up or down
if [ "$(cat /sys/class/net/wlan0/operstate)" = "up" ]; then
    # WiFi is up, so turn it down
	killall wpa_supplicant
    ip link set wlan0 down
    rename_pak "Enable WiFi.pak"
    log_message "WiFi disabled"
else
    # WiFi is down, so turn it up
    ip link set wlan0 up
	sleep 2
	wpa_supplicant -i wlan0 -D nl80211 -c /etc/wifi/wpa_supplicant.conf -B
	sleep 2
	udhcpc -i wlan0
    rename_pak "Disable WiFi.pak"
    log_message "WiFi enabled"
fi
