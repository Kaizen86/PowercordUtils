#!/bin/bash

TITLE="Powercord Theme Manager"
SIZE="25 80 10"
THEMESOURCE="$(pwd)/Themes"
THEME
if [ -z "$(ls -A $THEMEDIR)" ]; then
	whiptail --msgbox\
		--backtitle "$TITLE" --title "$TITLE"\
		"You do not appear to have any themes in\n\
\"$THEMEDIR\".\n\
\n\
Please add some to that folder and then rerun this utility."\
		$SIZE
else
	# Create an array of the folders present for Whiptail to use
	i=0
	for folder in "$THEMEDIR"/*
	do
		files[i]=$(( i/3 )) # Entry number
		files[i+1]="$folder" # Theme name
		files[i+2]="OFF" # Default state should be unchecked
		((i+=3)) # Increment index counter
	done
	
	# Show the selection menu
	whiptail --checklist\
		--scrolltext\
		--backtitle "$TITLE" --title "$TITLE"\
		--ok-button "Install" --cancel-button "No, thanks"\
		"We see you have some Powercord Themes, select the ones you wish to add here."\
		$SIZE\
		"${files[@]}" # Include the array of items created just now
fi
