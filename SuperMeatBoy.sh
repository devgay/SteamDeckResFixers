#!/bin/bash

# Super Meat Boy
# This game stores its config data in a binary file
# I was able to deduce what the offsets were for the resolution though

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
export FILE="/run/media/deck/SteamDeckSD/steamapps/common/Super Meat Boy/UserData/Reg0.dat"

# Check if file exists
if [ ! -f "$FILE" ] ; then
    printf "\033[1;36m[RES_HELPER]: Config not found, first launch?\033[0m\n"
    exit 0
fi

# Width is at 0x5C
# Height is at 0x64

# Grab hex of resolution
# Since none of the resolutions we can reach will ever exceed three digits we can just add the zero
WIDTH_HEX="0x0$(printf '%x\n' $(echo $DECK_SCR_WIDTH))"
HEIGHT_HEX="0x0$(printf '%x\n' $(echo $DECK_SCR_HEIGHT))"

# Swap bytes to Little Endian
WIDTH_LE=$(printf "%x\n" $(( (($WIDTH_HEX & 0xFF) << 8) | ($WIDTH_HEX >> 8) )))
HEIGHT_LE=$(printf "%x\n" $(( (($HEIGHT_HEX & 0xFF) << 8) | ($HEIGHT_HEX >> 8) )))

#Final processed string, formatted like this: \x38\x04
WIDTH_FINAL="\x${WIDTH_LE:0:2}\x${WIDTH_LE:2:2}"
HEIGHT_FINAL="\x${HEIGHT_LE:0:2}\x${HEIGHT_LE:2:2}"

# Apply config changes
printf $WIDTH_FINAL | dd conv=notrunc of="$FILE" bs=1 seek=$((0x5C))
printf $HEIGHT_FINAL | dd conv=notrunc of="$FILE" bs=1 seek=$((0x64))



