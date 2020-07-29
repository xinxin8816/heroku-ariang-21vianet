#!/bin/bash

sudo apt-get install p7zip
sudo apt-get install rar
sudo apt-get install unrar
sudo apt-get install p7zip-rar

if [[ -n $RCLONE_CONFIG && -n $RCLONE_DESTINATION ]]; then
	echo "Rclone config detected"
	echo -e "$RCLONE_CONFIG" > rclone.conf
	echo -e "$UNPACK_PASSWORDS" > passwds.txt
	echo "on-download-complete=./on-complete.sh" >> aria2c.conf
	echo "on-download-stop=./on-stop.sh" >> aria2c.conf
	chmod +x on-complete.sh
	chmod +x on-stop.sh
	chmod +x unpack.sh
fi

echo "rpc-secret=$ARIA2C_SECRET" >> aria2c.conf
aria2c -q --conf-path=aria2c.conf&
yarn start
