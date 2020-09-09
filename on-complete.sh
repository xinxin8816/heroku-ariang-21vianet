#!/bin/bash
# Aria2 Autoupload.sh by P3TERX, adapt Heroku-AriaNG by xinxin8816 and Kwok1am.

## 文件过滤 File Filter ##

# 限制最低上传大小，仅 BT 多文件下载时有效，用于过滤无用文件。低于此大小的文件将被删除，不会上传。
# Limit the minimum upload size, which is only valid when downloading multiple BT files, and is used to filter useless files. Files below this size will be deleted and will not be uploaded.
#MIN_SIZE=10m

# 保留文件类型，仅 BT 多文件下载时有效，用于过滤无用文件。其它文件将被删除，不会上传。
# Keep the file type, only effective when downloading multiple BT files, used to filter useless files. Other files will be deleted and will not be uploaded.
#INCLUDE_FILE='mp4,mkv,rmvb,mov'

# 排除文件类型，仅 BT 多文件下载时有效，用于过滤无用文件。排除的文件将被删除，不会上传。
# Exclude file types, valid only when downloading multiple BT files, used to filter useless files. Excluded files will be deleted and will not be uploaded.
#EXCLUDE_FILE='html,url,lnk,txt,jpg,png'

## 高级设置 advanced settings ##

# RCLONE 配置文件路径
# RCLONE Configuration file path
export RCLONE_CONFIG=rclone.conf

# RCLONE 并行上传文件数，仅对单个任务有效。
# RCLONE The number of files uploaded in parallel is only valid for a single task.
#export RCLONE_TRANSFERS=4

# RCLONE 块的大小，默认5M，理论上是越大上传速度越快，同时占用内存也越多。如果设置得太大，可能会导致进程中断。
# RCLONE The size of the block, the default is 5M. Theoretically, the larger the upload speed, the faster it will occupy more memory. If the setting is too large, the process may be interrupted.
export RCLONE_CACHE_CHUNK_SIZE=3M

# RCLONE 块可以在本地磁盘上占用的总大小，默认10G。
# RCLONE The total size that the block can occupy on the local disk, the default is 10G.
#export RCLONE_CACHE_CHUNK_TOTAL_SIZE=10G

# RCLONE 上传失败重试次数，默认 3
# RCLONE Upload failed retry count, the default is 3
#export RCLONE_RETRIES=3

# RCLONE 上传失败重试等待时间，默认禁用，单位 s, m, h
# RCLONE Upload failure retry wait time, the default is disabled, unit s, m, h
export RCLONE_RETRIES_SLEEP=30s

# RCLONE 异常退出重试次数
# RCLONE Abnormal exit retry count
RETRY_NUM=3

#============================================================

DOWNLOAD_PATH='downloads'
FILE_PATH=$3                                          # Aria2传递给脚本的文件路径。BT下载有多个文件时该值为文件夹内第一个文件，如/root/Download/a/b/1.mp4
REMOVE_DOWNLOAD_PATH=${FILE_PATH#${DOWNLOAD_PATH}/}   # 路径转换，去掉开头的下载路径。
TOP_PATH=${DOWNLOAD_PATH}/${REMOVE_DOWNLOAD_PATH%%/*} # 路径转换，BT下载文件夹时为顶层文件夹路径，普通单文件下载时与文件路径相同。
INFO="[INFO]"
ERROR="[ERROR]"
WARRING="[WARRING]"

TASK_INFO() {
    echo -e "
-------------------------- [TASK INFO] --------------------------
Download path: ${DOWNLOAD_PATH}
File path: ${FILE_PATH}
Upload path: ${UPLOAD_PATH}
Remote path A: ${REMOTE_PATH}
Remote path B: ${REMOTE_PATH_2}
-------------------------- [TASK INFO] --------------------------
"
}

CLEAN_UP() {
    [[ -n ${MIN_SIZE} || -n ${INCLUDE_FILE} || -n ${EXCLUDE_FILE} ]] && echo -e "${INFO} Clean up excluded files ..."
    [[ -n ${MIN_SIZE} ]] && rclone delete -v "${UPLOAD_PATH}" --max-size ${MIN_SIZE}
    [[ -n ${INCLUDE_FILE} ]] && rclone delete -v "${UPLOAD_PATH}" --exclude "*.{${INCLUDE_FILE}}"
    [[ -n ${EXCLUDE_FILE} ]] && rclone delete -v "${UPLOAD_PATH}" --include "*.{${EXCLUDE_FILE}}"
}

UPLOAD_FILE() {
    RETRY=0
	echo "$(($(cat numUpload)+1))" > numUpload # Plus 1
    while [ ${RETRY} -le ${RETRY_NUM} ]; do
        [ ${RETRY} != 0 ] && (
            echo
            echo -e "$(date +"%m/%d %H:%M:%S") ${ERROR} ${UPLOAD_PATH} Upload failed! Retry ${RETRY}/${RETRY_NUM} ..."
            echo
        )
        rclone copy -v "${UPLOAD_PATH}" "${REMOTE_PATH}"
        RCLONE_EXIT_CODE=$?
		RCLONE_EXIT_CODE_2=0
		if [ -n "${RCLONE_DESTINATION_2}" ]; then
			rclone copy -v "${UPLOAD_PATH}" "${REMOTE_PATH_2}"
			RCLONE_EXIT_CODE_2=$?
		fi
        if [ ${RCLONE_EXIT_CODE} -eq 0 ] && [ ${RCLONE_EXIT_CODE_2} -eq 0 ]; then
            [ -e "${DOT_ARIA2_FILE}" ] && rm -vf "${DOT_ARIA2_FILE}"
            rclone rmdirs -v "${DOWNLOAD_PATH}" --leave-root
            echo -e "$(date +"%m/%d %H:%M:%S") ${INFO} Upload done: ${UPLOAD_PATH}"
			rclone delete -v "${UPLOAD_PATH}"
            break
        else
            RETRY=$((${RETRY} + 1))
            [ ${RETRY} -gt ${RETRY_NUM} ] && (
                echo
                echo -e "$(date +"%m/%d %H:%M:%S") ${ERROR} Upload failed: ${UPLOAD_PATH}"
                echo
            )
            sleep 3
        fi
    done
	echo "$(($(cat numUpload)-1))" > numUpload # Minus 1
}

UPLOAD() {
    echo -e "$(date +"%m/%d %H:%M:%S") ${INFO} Start upload..."
    TASK_INFO
    UPLOAD_FILE
}

if [ -z $2 ]; then
    echo && echo -e "${ERROR} This script can only be used by passing parameters through Aria2."
    echo && echo -e "${WARRING} 直接运行此脚本可能导致无法开机！"
    exit 1
elif [ $2 -eq 0 ]; then
    exit 0
fi

if [ -e "${FILE_PATH}.aria2" ]; then
    DOT_ARIA2_FILE="${FILE_PATH}.aria2"
elif [ -e "${TOP_PATH}.aria2" ]; then
    DOT_ARIA2_FILE="${TOP_PATH}.aria2"
fi

if [ "${TOP_PATH}" = "${FILE_PATH}" ] && [ $2 -eq 1 ]; then # 普通单文件下载，移动文件到设定的网盘文件夹。
	name=`basename "${FILE_PATH}"`
	filename="${name%%.*}"
	. /app/unpack.sh "${FILE_PATH}" "${filename}"
	UPLOAD_PATH="${FILE_PATH%/*}"/"${filename}"
    REMOTE_PATH="${RCLONE_DESTINATION}/"
    REMOTE_PATH_2="${RCLONE_DESTINATION_2}/"
    UPLOAD
    exit 0
elif [ "${TOP_PATH}" != "${FILE_PATH}" ] && [ $2 -gt 1 ]; then # BT下载（文件夹内文件数大于1），移动整个文件夹到设定的网盘文件夹。
	. /app/unpack.sh "${TOP_PATH}"
    UPLOAD_PATH="${TOP_PATH}"
    REMOTE_PATH="${RCLONE_DESTINATION}/${REMOVE_DOWNLOAD_PATH%%/*}"
	REMOTE_PATH_2="${RCLONE_DESTINATION_2}/${REMOVE_DOWNLOAD_PATH%%/*}"
    CLEAN_UP
    UPLOAD
    exit 0
elif [ "${TOP_PATH}" != "${FILE_PATH}" ] && [ $2 -eq 1 ]; then # 第三方度盘工具下载（子文件夹或多级目录等情况下的单文件下载）、BT下载（文件夹内文件数等于1），移动文件到设定的网盘文件夹下的相同路径文件夹。
	name=`basename "${FILE_PATH}"`
	filename="${name%%.*}"
	. /app/unpack.sh "${FILE_PATH}" "${filename}"
    UPLOAD_PATH="${FILE_PATH}"/"${filename}"
    REMOTE_PATH="${RCLONE_DESTINATION}/${REMOVE_DOWNLOAD_PATH%/*}"
	REMOTE_PATH_2="${RCLONE_DESTINATION_2}/${REMOVE_DOWNLOAD_PATH%/*}"
    UPLOAD
    exit 0
fi

echo -e "${ERROR} Unknown error."
TASK_INFO
exit 1
