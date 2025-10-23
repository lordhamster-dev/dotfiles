#!/bin/sh

# Wi-Fi connection script using nmcli and fuzzel

# Get a list of available Wi-Fi networks, handling potential duplicates and empty lines
SSIDS=$(nmcli --fields SSID device wifi list | sed '/^--/d' | sed 's/SSID//' | sed '/^\s*$/d' | awk '{$1=$1};1' | uniq)

# Use fuzzel to select a network
CHOSEN_SSID=$(printf "%s" "$SSIDS" | fuzzel -d --width 30)

# Exit if no network is chosen
[ -z "$CHOSEN_SSID" ] && exit

# Check if a connection profile for the selected SSID already exists
if nmcli connection show --active | grep -q "$CHOSEN_SSID"; then
    notify-send "Wi-Fi" "Already connected to '$CHOSEN_SSID'"
    exit
fi

# If a profile exists but is inactive, try to bring it up
if nmcli connection show | grep -q "$CHOSEN_SSID"; then
    nmcli connection up "$CHOSEN_SSID" && notify-send "Wi-Fi" "Connected to '$CHOSEN_SSID'"
else
    # If no profile exists, ask for a password
    PASSWORD=$(fuzzel -d --password --prompt " Password for $CHOSEN_SSID: ")
    # Exit if no password is provided
    [ -z "$PASSWORD" ] && exit

    # Try to connect with the provided password
    nmcli device wifi connect "$CHOSEN_SSID" password "$PASSWORD" && notify-send "Wi-Fi" "Connected to '$CHOSEN_SSID'"
fi
