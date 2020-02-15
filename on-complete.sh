#!/bin/bash

filePath=$3
relativePath=${filepath#./downloads/}
topPath=./downloads/${relativePath%%/*} # It will be the path of folder when it has multiple files, otherwise it will be the same as file path.

echo "$(($(cat numUpload)+1))" > numUpload # Plus 1

if [[ $2 -eq 1 ]]; then # single file
	rclone -v --config="rclone.conf" --no-traverse copy "$3" "DRIVE:$RCLONE_DESTINATION" 2>&1
	rclone -v --config="rclone2.conf" --delete-empty-src-dirs --no-traverse move "$3" "DRIVE:$RCLONE_DESTINATION2" 2>&1	
elif [[ $2 -gt 1 ]]; then # multiple file
	rclone -v --config="rclone.conf" --no-traverse copy "$topPath" "DRIVE:$RCLONE_DESTINATION/${relativePath%%/*}"
	rclone -v --config="rclone2.conf" --delete-empty-src-dirs --no-traverse move "$topPath" "DRIVE:$RCLONE_DESTINATION2/${relativePath%%/*}"
fi


echo "$(($(cat numUpload)-1))" > numUpload # Minus 1
