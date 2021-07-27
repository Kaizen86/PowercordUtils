#!/bin/bash

echo $(pwd)

echo "Do you wish to proceed with reinstalling Canary?"
select answer in "Confirm" "Cancel"
do
	case $answer in
		Confirm) break;;
		Cancel) exit;;
	esac
done

# https://askubuntu.com/questions/157779/how-to-determine-whether-a-process-is-running-or-not-and-make-use-it-to-make-a-c
# Check to make sure that Discord isn't running, and ask to close it if so.
if pgrep -x "DiscordCanary" > /dev/null; then
    read -p "
Warning - Unable to proceed!
Discord Canary is still running, and must be closed to reinstall.
Press Enter to quit Discord. "
	killall DiscordCanary
fi


# Remove the directories if they already exist
if [ -d "powercord" ]; then
	echo "Removing DiscordCanary/"
	rm -rf powercord
fi
if [ -d "DiscordCanary" ]; then
	echo "Removing DiscordCanary/"
	rm -rf DiscordCanary
fi
# Sometimes, there are a few files that are stubborn to remove.
if [ -d "DiscordCanary" ]; then
	echo ">:( Forcibly removing DiscordCanary/"
	sudo rm -rf DiscordCanary
fi


# Download and unpack Canary
echo "Downloading Discord Canary..."
wget --show-progress --quiet "https://discordapp.com/api/download/canary?platform=linux&format=tar.gz" -O discord.tar.gz
echo "Unpacking tar.gz..."
tar -xf discord.tar.gz
rm discord.tar.gz

# Clone the powercord repository
echo "Cloning powercord..."
git clone https://github.com/powercord-org/powercord 1>/dev/null

# We have to patch the powercord injector plug in order to recognise our custom install folder automatically.
# If this is not done, the user is prompted to manually specify the DiscordCanary folder we just downloaded.
INSTALL_DIR="$(pwd)/DiscordCanary"
echo "
Patching install script to recognise our folderpath automatically.
If this fails, it will ask you for the location of Canary.
In the event that you get prompted, paste in: \"$INSTALL_DIR\"
"
sed --in-place "/^const KnownLinuxPaths.*/a\ \ '$INSTALL_DIR'," powercord/injectors/linux.js

# Standard powercord installation procedures.
echo "Installing powercord"
cd powercord
npm i
npm run unplug # Just in case, run unplug first.
npm run plug
cd ..

echo "
All done!
"

# Start Discord automatically :)
./DiscordCanary/DiscordCanary
