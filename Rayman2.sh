#!/bin/bash

# Rayman 2: The Great Escape
# Renderer *shouldn't* matter but this was done with Glide

shopt -s expand_aliases

# Grab dimensions of XWAYLAND1
export DECK_SCR_RES=$(xrandr -d :1 | grep ' connected ' | cut -d ' ' -f 3)
export DECK_SCR_WIDTH=$(echo $DECK_SCR_RES | cut -d 'x' -f 1)
export DECK_SCR_HEIGHT=$(echo $DECK_SCR_RES | cut -d 'x' -f 2 | cut -d '+' -f 1)

# Check if we are in Game mode
if [ -z $DECK_SCR_RES ] ; then # If there is no second X server it will just be empty
    printf "\033[1;36m[RES_HELPER]: Not in Game Mode! Skipping...\033[0m\n"
    exit 0
fi

# Output to gamescope user log
printf "\033[1;36m[RES_HELPER]: Forcing resolution to $DECK_SCR_WIDTH x $DECK_SCR_HEIGHT\033[0m\n"

# Set var to file path(s) for easier writing
export FILE="/run/media/deck/SteamDeckSD/NonSteam/Microsoft Windows/Rayman 2 - The Great Escape/ubi.ini"

# Check if file exists
if [ ! -f "$FILE" ] ; then
    printf "\033[1;36m[RES_HELPER]: Config not found, first launch?\033[0m\n"
    exit 0
fi

FINAL_RENDER_WIDTH=$(python -c "print(round((640 / 480) * $DECK_SCR_HEIGHT))") # Calculate 4x3 Width from Height

# Apply config changes
sed -i "s/GLI_Mode=.*/GLI_Mode=1 - $FINAL_RENDER_WIDTH x $DECK_SCR_HEIGHT x 32/" "$FILE"
