#!/bin/bash

# A Hat in Time
# This game needs the resolution to be set in THREE PLACES
# WHY

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
export FILE1="/run/media/deck/SteamDeckSD/steamapps/common/HatinTime/HatinTimeGame/Config/HatinTimeSystemSettings.ini"
export FILE2="/run/media/deck/SteamDeckSD/steamapps/common/HatinTime/HatinTimeGame/Config/HatinTimeSystemSettings.ini"
export FILE3="/run/media/deck/SteamDeckSD/steamapps/common/HatinTime/Engine/Config/BaseSystemSettings.ini"
export FILE4="/run/media/deck/SteamDeckSD/steamapps/common/HatinTime/HatinTimeGame/Config/DefaultSystemSettings.ini"

# Apply config changes
sed -i "s/ResX=.*/ResX=$DECK_SCR_WIDTH/" "$FILE1"
sed -i "s/ResY=.*/ResY=$DECK_SCR_HEIGHT/" "$FILE1"

sed -i "s/SecondaryDisplayMaximumWidth=.*/SecondaryDisplayMaximumWidth=$DECK_SCR_WIDTH/" "$FILE2"
sed -i "s/SecondaryDisplayMaximumHeight=.*/SecondaryDisplayMaximumHeight=$DECK_SCR_HEIGHT/" "$FILE2"

sed -i "s/ResX=.*/ResX=$DECK_SCR_WIDTH/" "$FILE3"
sed -i "s/ResY=.*/ResY=$DECK_SCR_HEIGHT/" "$FILE3"

sed -i "s/ResX=.*/ResX=$DECK_SCR_WIDTH/" "$FILE4"
sed -i "s/ResY=.*/ResY=$DECK_SCR_HEIGHT/" "$FILE4"
