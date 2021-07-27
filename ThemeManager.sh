#!/bin/bash

TITLE="Powercord Theme Manager"
SIZE="25 80 10"

# I am assuming this utility is being used in conjunction with the FullReinstall.sh script
# Change this variable if this is not the case.
POWERCORD_DIR="$(pwd)/powercord" 
# I've placed my Themes folder alongside the utility, but this can be wherever you keep your themes.
THEMESOURCE="/" #"$(pwd)/Themes"

ShowError() {
	whiptail --msgbox\
		--backtitle "$TITLE" --title "$TITLE"\
		"Internal error, unable to proceed.\n${@:1}"\
		$SIZE
}

# Sanity checks - Make sure Powercord and its appropriate structure exists
POWERCORD_THEMES="$POWERCORD_DIR/src/Powercord/themes" # Do NOT modify unless the structure of Powercord has changed
if [ ! -d "$POWERCORD_DIR" ]; then
	ShowError "\"$POWERCORD_DIR\" does not appear to exist.\n\n
Please verify the location for Powercord is configured correctly and retry."
	exit 1
elif [ ! -d "$POWERCORD_THEMES" ]; then
	ShowError "\"$POWERCORD_THEMES\" does not appear to exist.\n\n
Please verify this utility is configured correctly and retry."
	exit 1

# What about the user's theme folder? Does that have anything in it?
elif [ -z "$(ls -A $THEMESOURCE)" ]; then
	ShowError "You do not appear to have any themes in\n\
\"$THEMESOURCE\".\n\n\
Please add some to that folder and then rerun this utility."
	exit 1

else
	# Create an array of the folders present for Whiptail to use
	i=0
	for folder in "$THEMESOURCE"/*/
	do
		files[i]=$(( i/3 )) # Entry number
		files[i+1]="$(basename $folder)" # Theme name
		files[i+2]="OFF" # Default state should be unchecked - TODO: Make this dependent on if POWERCORD_THEMES has the same theme installed, to make the box reflect the current state.
		((i+=3)) # Increment index counter
	done

	# Show the selection menu
	whiptail --checklist\
		--scrolltext\
		--backtitle "$TITLE" --title "$TITLE"\
		--ok-button "Install" --cancel-button "No, thanks"\
		"Please make a selection for themes to install:"\
		$SIZE\
		"${files[@]}" # Include the array of items created just now

	# TODO: Detect when the Cancel button is pressed

	# TODO: Parse the IDs returned by Whiptail back into folder paths
	#	Formula could look something like: $THEMESOURCE/$(( ${files[$ID/3+1]} ))
	#	NOTE: Might be more worthwhile to just store the paths when building the array?

	# Remove all folders in the Powercord Themes folder
	#rm -rfv "$POWERCORD_THEMES"

	# Copy chosen folders into the folder
	#cp -rv $idk "$POWERCORD_THEMES"
fi
