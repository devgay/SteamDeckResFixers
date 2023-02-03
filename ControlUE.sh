#!/bin/bash

# Control Ultimate Edition
# Also sets a resolution scale for the current res to get better performance
# Control is based and can accept just about any resolution for iRenderResolution :)

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
export FILE="/run/media/deck/SteamDeckSD/steamapps/common/Control/renderer.ini"

# Check if file exists
if [ ! -f "$FILE" ] ; then
    printf "\033[1;36m[RES_HELPER]: Config not found, first launch?\033[0m\n"
    exit 0
fi

# res scale
SCALE=0.63
FINAL_RENDER_WIDTH=$(python -c "print(round($DECK_SCR_WIDTH * $SCALE))") # calculate render width & round
FINAL_RENDER_HEIGHT=$(python -c "print(round(($DECK_SCR_HEIGHT / $DECK_SCR_WIDTH) * $FINAL_RENDER_WIDTH))") # calculate render height via ((oldHeight / oldWidth) * renderWidth) & round

# Output to gamescope user log
printf "\033[1;36m[RES_HELPER]: Forcing render resolution to $FINAL_RENDER_WIDTH x $FINAL_RENDER_HEIGHT ($SCALE)\033[0m\n"

# Apply config changes
sed -i "s/\"m_iOutputResolutionY\": .*/\"m_iOutputResolutionY\": $(echo $DECK_SCR_HEIGHT),/" "$FILE"
sed -i "s/\"m_iOutputResolutionX\": .*/\"m_iOutputResolutionX\": $(echo $DECK_SCR_WIDTH),/" "$FILE"
sed -i "s/\"m_iRenderResolutionY\": .*/\"m_iRenderResolutionY\": $(echo $FINAL_RENDER_HEIGHT),/" "$FILE"
sed -i "s/\"m_iRenderResolutionX\": .*/\"m_iRenderResolutionX\": $(echo $FINAL_RENDER_WIDTH),/" "$FILE"

#jesus christ
