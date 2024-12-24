#!/bin/sh
FILE="/sys/class/disp/disp/attr/color_temperature"
SETTINGS_FILE="/mnt/SDCARD/.userdata/$PLATFORM/display_settings.conf"

save_settings() {
    # Create directory if it doesn't exist
    mkdir -p "$(dirname "$SETTINGS_FILE")"
    
    # Save current settings to file
    echo "color_temperature=$1" > "$SETTINGS_FILE"
    
    # If we're in the modes that need additional settings, save those too
    if [ "$1" -eq 100 ]; then
        echo "enhance_saturation=40" >> "$SETTINGS_FILE"
        echo "enhance_contrast=45" >> "$SETTINGS_FILE"
    elif [ "$1" -eq 150 ]; then
        echo "enhance_saturation=30" >> "$SETTINGS_FILE"
        echo "enhance_contrast=35" >> "$SETTINGS_FILE"
    else
        # Reset additional settings
        echo "enhance_saturation=0" >> "$SETTINGS_FILE"
        echo "enhance_contrast=0" >> "$SETTINGS_FILE"
    fi
}

main() {
    # Read current value
    current=$(cat $FILE)
    
    # Cycle through values
    if [ "$current" -eq 0 ]; then
        echo 20 > $FILE
        save_settings 20
        echo "Changed color temperature to 20"
    elif [ "$current" -eq 20 ]; then
        echo 50 > $FILE
        save_settings 50
        echo "Changed color temperature to 50"
    elif [ "$current" -eq 50 ]; then
        echo 100 > $FILE
        echo 40 > /sys/class/disp/disp/attr/enhance_saturation
        echo 45 > /sys/class/disp/disp/attr/enhance_contrast
        save_settings 100
        echo "Changed color temperature to 100"
    elif [ "$current" -eq 100 ]; then
        echo 150 > $FILE
        echo 30 > /sys/class/disp/disp/attr/enhance_saturation
        echo 35 > /sys/class/disp/disp/attr/enhance_contrast
        save_settings 150
        echo "Changed color temperature to 150"
    else
        echo "Current value is $current (setting to 0)"
        echo 0 > $FILE
        save_settings 0
    fi
}

main