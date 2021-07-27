#!/bin/bash

TITLE="Powercord Theme Manager"
SIZE="25 80 10"

# I am assuming this utility is being used in conjunction with the FullReinstall.sh script
# Change this variable if this is not the case.
POWERCORD_DIR="$(pwd)/powercord" 
# I've placed my Themes folder alongside the utility, but this can be wherever you keep your themes.
THEMESOURCE="$(pwd)/Themes"

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
	for folder in "$THEMESOURCE"/*/; do
		themes[i]=$(( i/3 )) # Entry number
		themes[i+1]="$(basename $folder)  " # Theme name
		themes[i+2]="OFF" # Default state should be unchecked - TODO: Make this dependent on if POWERCORD_THEMES has the same theme installed, to make the box reflect the current state.
		((i+=3)) # Increment index counter
	done
	
	 # Due to IO stream nonsense, I am essentially forced to write the result to a file
	 # instead of storing it directly into a variable. I didn't want to do this, however 
	 # I have been bashing my head against this for an hour now and frankly I don't care.
	exec 3> /tmp/whiptail_stderr # Open an IO stream into a temporary file
	
	# Show the selection menu, redirecting its stderr to our temporary file
	whiptail --checklist\
		--backtitle "$TITLE" --title "$TITLE"\
		--ok-button "Install" --cancel-button "No, thanks"\
		"Please make a selection for themes to install:"\
		$SIZE\
		"${themes[@]}" 2>&3
	exec 3>&- # Close the IO stream
	
	# Read the temporary file into a variable and tidy up
	choices=$(tr -d '"' < /tmp/whiptail_stderr)
	rm /tmp/whiptail_stderr
	
	# Detect when the Cancel button is pressed
	if [[ ! $choices ]]; then
		echo "Goodbye!"
		exit 0
	fi
	
	# Remove all folders in the Powercord Themes folder
	rm -rfv "$POWERCORD_THEMES"/*
	
	# Loop over each selected theme
	for ID in $choices; do
		# Parse the IDs returned by Whiptail back into folder paths
		src="$THEMESOURCE/${themes[$(( $ID/3+1 ))]}"
		
		# Copy chosen folders into the folder
		cp -rv $src "$POWERCORD_THEMES"
	done
fi
