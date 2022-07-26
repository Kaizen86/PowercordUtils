#!/bin/sh
while pgrep -x "DiscordCanary" &> /dev/null; do # It can take a few tries
	killall DiscordCanary
done
