#!/bin/bash

TITLE="Powercord Theme Manager"
SIZE="25 80 10"

# I am assuming this script is being used in conjunction with the FullReinstall.sh script
# Change these variables if this is not the case.
POWERCORD_DIR="$(pwd)/powercord" 
THEMESOURCE="$(pwd)/Themes" # I've placed my Themes folder alongside the script

ShowError() {
	whiptail --msgbox\
		--backtitle "$TITLE" --title "$TITLE"\
		"INTERNAL ERROR!\n\
${@:1}\n\
\n\
Please verify this script is configured correctly and retry."\
		$SIZE
}

# Sanity checks - Make sure Powercord and its appropriate structure exists
POWERCORD_THEMES="$POWERCORD_DIR/src/Powercord/themes" # Do NOT modify unless the structure of Powercord has changed
if [ ! -d "$POWERCORD_DIR" ]; then
	ShowError "\"$POWERCORD_DIR\" does not appear to exist."
	exit 1
elif [ ! -d "$POWERCORD_THEMES" ]; then
	ShowError "\"$POWERCORD_THEMES\" does not appear to exist."
	exit 1
	
# What about the user's theme folder? Does that have anything in it?
elif [ -z "$(ls -A $THEMESOURCE)" ]; then
	whiptail --msgbox\
		--backtitle "$TITLE" --title "$TITLE"\
		"You do not appear to have any themes in\n\
\"$THEMESOURCE\".\n\
\n\
Please add some to that folder and then rerun this utility."\
		$SIZE
	exit 1
		
else
	# Create an array of the folders present for Whiptail to use
	i=0
	for folder in "$THEMESOURCE"/*
	do
		files[i]=$(( i/3 )) # Entry number
		files[i+1]="$(basename $folder)" # Theme name
		files[i+2]="OFF" # Default state should be unchecked
		((i+=3)) # Increment index counter
	done
	
	# Show the selection menu
	whiptail --checklist\
		--scrolltext\
		--backtitle "$TITLE" --title "$TITLE"\
		--ok-button "Install" --cancel-button "No, thanks"\
		"We see you have some Powercord Themes, select the ones you wish to use."\
		$SIZE\
		"${files[@]}" # Include the array of items created just now
		
	# Remove all folders in the Powercord Themes folder
	#rm -rfv "$POWERCORD_DIR/src/Powercord/themes"
	
	# Copy chosen folders into the folder
	#cp -rv $idk "$POWERCORD_DIR/src/Powercord/themes"
	
	exit 0
fi
