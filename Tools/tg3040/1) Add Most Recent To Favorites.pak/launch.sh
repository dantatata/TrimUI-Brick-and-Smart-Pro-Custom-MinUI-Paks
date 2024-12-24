#!/bin/sh

# Define paths
RECENTS="/mnt/SDCARD/.userdata/shared/.minui/recent.txt"
FAVORITES="/mnt/SDCARD/Collections/Favorites.txt"

# Check if recent.txt exists
if [ ! -f "$RECENTS" ]; then
    echo "Error: Recent games file not found at $RECENTS"
    exit 1
fi

# Create Favorites.txt and its directory if they don't exist
FAVORITES_DIR=$(dirname "$FAVORITES")
if [ ! -d "$FAVORITES_DIR" ]; then
    if ! mkdir -p "$FAVORITES_DIR"; then
        echo "Error: Could not create directory $FAVORITES_DIR"
        exit 1
    fi
fi

if [ ! -f "$FAVORITES" ]; then
    if ! touch "$FAVORITES"; then
        echo "Error: Could not create $FAVORITES"
        exit 1
    fi
fi

# Check if Favorites is writable
if [ ! -w "$FAVORITES" ]; then
    echo "Error: Cannot write to Favorites file at $FAVORITES"
    exit 1
fi

# Get first line from recents file and remove everything after tab
first_line=$(head -n 1 "$RECENTS" | cut -f 1)

# Check if we got a line
if [ -z "$first_line" ]; then
    echo "Error: No recent games found in $RECENTS"
    exit 1
fi

# Check if the game is already in favorites to avoid duplicates
if grep -Fxq "$first_line" "$FAVORITES"; then
    echo "Game already in favorites"
    exit 0
fi

# Append to favorites file
echo "$first_line" >> "$FAVORITES"

if [ $? -eq 0 ]; then
    echo "Successfully added to favorites: $first_line"
else
    echo "Error: Failed to add game to favorites"
    exit 1
fi