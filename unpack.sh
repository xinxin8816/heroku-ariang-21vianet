#!/bin/bash

# Unpack Archive Beta

delete=0
cur=`dirname $0`     
dst="$2"

trypassds(){
	dir=`dirname "$1"`
	name=`basename "$1"`    
	if [ "$dst"  ]; then
		dir="$dir/$dst"
	fi
	a=`eval echo "$2" | tr -d '\r'`
	echo "Try Passwd：$a"
	files=`7za l "$1" -p"$a"|grep -w "\.\.\.\.\."|awk -F" " '{print $6}'`
	7za x "$1" -o"${dir}" -y -p"$a"
	if [ $? = 0 ] ;then
		echo "Unpack $name Success"
	return 0
	else
		cd $dir
		for line in $files
		do
			rm -rf ./$line
		done
	return 1
fi
}

unpackonefile(){
	dir=`dirname "$1"`
	name=`basename "$1"`
	echo "Unpack：$name  Dir：$dir"
	trypassds "$1"
	if [ $? = 0 ];then
		echo "Unpack $name Success"
	if [ $delete = 1 ];then
		rm "$1"
		echo "Delete $1"
	fi
	return 0
	else        
		for line in `cat /app/passwds.txt`
		do
		trypassds "$1" "$line"
		if [ $? = 0 ];then
			echo "Unpack $name Success by Brute Force！"
			if [ $delete = 1 ];then
				rm "$1"
				echo "Delete $1"
			fi
			return 0
		fi
		done
		echo "Unpack $name Failed"
		dir=`dirname "$1"`
		if [ "$dst"  ]; then
			dir="$dir"/"$dst"
			if [ ! -d "$dst" ];then
				mkdir "$dir"
			fi
			mv "$1" "$dir"
		fi
		return 1
	fi
}

unpackfile(){
	name=`basename "$1"`
	extision="${name##*.}"
	if [ "$extision" == "rar" ] || [ "$extision" == "zip" ] || [ "$extision" == "7z" ]|| [ "$extision" == "gz" ]|| [ "$extision" == "tar" ];then
		echo "extsion $extision"
		unpackonefile "$1"
		return 1
	else
		dir=`dirname "$1"`
		if [ "$dst"  ]; then
			dir="$dir"/"$dst"
			if [ ! -d "$dst" ];then
				mkdir "$dir"
			fi
			mv "$1" "$dir"
		fi
		return -1
	fi
}

unpackfolder(){
	for file in $1/* 
	do 
		if [ -d "$file" ]
		then
			echo "folder :$file"
			unpackfolder "$file"
		elif [ -f "$file" ]
		then
			echo "file:$file"
			unpackfile "$file"
		else
			echo "Error File"
		fi
	done
}
unpackall(){
	if [ -d "$1" ]
	then 
		echo "diectory"
		unpackfolder "$1"
	elif [ -f "$1" ]
	then
		echo "file"
		unpackfile "$1"
	else
		echo "No Such File Or Dir"
	fi
}

echo "Starting Unpack"
unpackall "$1"
