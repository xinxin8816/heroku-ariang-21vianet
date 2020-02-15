#!/bin/bash

if [[ -n $RCLONE_CONFIG && -n $RCLONE_DESTINATION ]]; then
	echo "Rclone config detected"
	echo -e "$RCLONE_CONFIG" > rclone.conf
	echo "on-download-complete=./on-complete.sh" >> aria2c.conf
	chmod +x on-complete.sh
fi

echo "rpc-secret=$ARIA2C_SECRET" >> aria2c.conf
aria2c --console-log-level=warn --conf-path=aria2c.conf&
yarn start
