#!/bin/bash

# Star Wars: The Force Unleashed: Ultimate Sith Edition

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
export FILE="/home/deck/.local/share/Steam/steamapps/compatdata/32430/pfx/drive_c/users/steamuser/AppData/Local/Aspyr/Star Wars The Force Unleashed/Config.xml"

# Check if file exists
if [ ! -f "$FILE" ] ; then
    printf "\033[1;36m[RES_HELPER]: Config not found, first launch?\033[0m\n"
    exit 0
fi

# Apply config changes
sed -i "s/<s id=\"VideoWidth\">.*/<s id=\"VideoWidth\">$DECK_SCR_WIDTH<\/s>/" "$FILE"
sed -i "s/<s id=\"VideoHeight\">.*/<s id=\"VideoHeight\">$DECK_SCR_HEIGHT<\/s>/" "$FILE"

# This totally mangles the config but it still works for some odd reason
