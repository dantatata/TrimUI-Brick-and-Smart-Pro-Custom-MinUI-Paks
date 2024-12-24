#!/bin/sh
# Get source directory
EMU_PATH="/mnt/SDCARD/Emus/$PLATFORM/N64.pak"

# Check if EMU_PATH exists
if [ ! -d "$EMU_PATH" ]; then
    echo "Error: Emulator path $EMU_PATH does not exist"
    exit 1
fi

# Check for standalone setup
if [ -f "$EMU_PATH/standalone.txt" ]; then
    # Check if source file exists
    if [ ! -f "$EMU_PATH/n64retroarch.sh" ]; then
        echo "Error: Source file n64retroarch.sh not found in $EMU_PATH"
        exit 1
    fi
    
    # Attempt to copy file
    if ! cp "$EMU_PATH/n64retroarch.sh" "$EMU_PATH/launch.sh"; then
        echo "Error: Failed to copy n64retroarch.sh to launch.sh"
        exit 1
    fi
    
    # Update status files
    rm "$EMU_PATH/standalone.txt"
    touch "$EMU_PATH/retroarch.txt"
    echo "Successfully installed retroarch launch script"

# Check for retroarch setup
elif [ -f "$EMU_PATH/retroarch.txt" ]; then
    # Check if source file exists
    if [ ! -f "$EMU_PATH/n64standalone.sh" ]; then
        echo "Error: Source file n64standalone.sh not found in $EMU_PATH"
        exit 1
    fi
    
    # Attempt to copy file
    if ! cp "$EMU_PATH/n64standalone.sh" "$EMU_PATH/launch.sh"; then
        echo "Error: Failed to copy n64standalone.sh to launch.sh"
        exit 1
    fi
    
    # Update status files
    rm "$EMU_PATH/retroarch.txt"
    touch "$EMU_PATH/standalone.txt"
    echo "Successfully installed standalone launch script"

else
    # No status file exists, create initial standalone status
    touch "$EMU_PATH/standalone.txt"
    
    # Check if source file exists
    if [ ! -f "$EMU_PATH/n64standalone.sh" ]; then
        echo "Error: Source file n64standalone.sh not found in $EMU_PATH"
        exit 1
    fi
    
    # Attempt to copy file
    if ! cp "$EMU_PATH/n64standalone.sh" "$EMU_PATH/launch.sh"; then
        echo "Error: Failed to copy n64standalone.sh to launch.sh"
        exit 1
    fi
    echo "Successfully installed initial standalone launch script"
fi