# Powercord Utilities
These are a small set of scripts to aid in the management of a Discord+Powercord installation. Sometimes it breaks, at least for me, and I have to reinstall it. Or perhaps I wanted to tweak a theme, and I would have to copy the theme into a hard-to-get-to folder. These annoyances got tiresome, so I wrote two scripts to automate them.
## Contents
* FullReinstall.sh
	
	This script does a few things, as its goal is to make the re/installation of Discord+Powercord as effortless as possible.
	It will wipe folders that it may have previously downloaded, re/download Discord, then Powercord.
	Powercord's plug is then run automatically, followed by the ThemeManager.sh script, then Discord is started.
* ThemeManager.sh
	
	This standalone script allows easy management of themes loaded into Powercord.
	It presents a menu that you can use to select which themes you wish to use from a folder, and then copies them into Powercord.
	If possible, it will offer to re/start Discord at the end of the procedure.
	
## Dependencies
There are a small handful of required packages and libraries for all this to work properly.
### Discord's requirements:
* libnss3
* libgbm-dev
### My requirements:
Listed are the programs needed by the shellscripts that may need to be installed, along with a brief description of what the command is needed for.
* `wget` (Download Discord)
* `git` (Download Powercord)
* `sed` (Automating Powercord install)
* `npm` (Install Powercord)
* `whiptail` (Displays the menus in the Theme Manager)
