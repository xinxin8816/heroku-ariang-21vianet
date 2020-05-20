#!/usr/bin/env bash
# Aria2 Delete.sh by P3TERX, adapt Heroku-AriaNG by xinxin8816.

DOWNLOAD_PATH='downloads'
FILE_PATH=$3
RELATIVE_PATH=${FILE_PATH#${DOWNLOAD_PATH}/}
TOP_PATH=${DOWNLOAD_PATH}/${RELATIVE_PATH%%/*}
INFO="[INFO]"

echo -e "$(date +"%m/%d %H:%M:%S") ${INFO} Download error or stop, start deleting files..."

if [ $2 -eq 0 ]; then
    exit 0
elif [ -e "${FILE_PATH}.aria2" ]; then
    rm -vf "${FILE_PATH}.aria2" "${FILE_PATH}"
elif [ -e "${TOP_PATH}.aria2" ]; then
    rm -vrf "${TOP_PATH}.aria2" "${TOP_PATH}"
fi
find "${DOWNLOAD_PATH}" ! -path "${DOWNLOAD_PATH}" -depth -type d -empty -exec rm -vrf {} \;
