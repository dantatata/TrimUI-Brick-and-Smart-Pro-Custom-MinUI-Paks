#!/bin/sh

# default
echo 50 > /sys/class/disp/disp/attr/enhance_contrast
echo 60 > /sys/class/disp/disp/attr/enhance_saturation

# set display settings to last set by user
SETTINGS_FILE="/mnt/SDCARD/.userdata/$PLATFORM/display_settings.conf"

# check if settings file exists
if [ -f "$SETTINGS_FILE" ]; then
    # Read and apply settings
    while IFS='=' read -r key value; do
        case "$key" in
            "color_temperature")
                echo "$value" > /sys/class/disp/disp/attr/color_temperature
                ;;
            "enhance_saturation")
                echo "$value" > /sys/class/disp/disp/attr/enhance_saturation
                ;;
            "enhance_contrast")
                echo "$value" > /sys/class/disp/disp/attr/enhance_contrast
                ;;
        esac
    done < "$SETTINGS_FILE"
fi

# reset pak name for wifi
BASE_PATH="/mnt/SDCARD/Tools/$PLATFORM/" 
if [ -d "$BASE_PATH/Settings/1) Enable WiFi.pak" ]; then
    mv "$BASE_PATH/Settings/1) Enable WiFi.pak" "$BASE_PATH/Settings/1) Toggle WiFi.pak"
elif [ -d "$BASE_PATH/Settings/1) Disable WiFi.pak" ]; then
    mv "$BASE_PATH/Settings/1) Disable WiFi.pak" "$BASE_PATH/Settings/1) Toggle WiFi.pak"
fi
