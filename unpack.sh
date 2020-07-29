#!/bin/bash

#文件解压

delete=1
cur=`dirname $0`     
dst="$2"

trypassds(){
	dir=`dirname "$1"`
	name=`basename "$1"`    
	if [ "$dst"  ]; then
		dir="$dir/$dst"
	fi
	# 去除密码两边的空格和换行符
	a=`eval echo "$2" | tr -d '\r'`
	echo "尝试密码 ：$a"
	# 保存里面的文件
	files=`7z l "$1" -p"$a"|grep -w "\.\.\.\.\."|awk -F" " '{print $6}'` #文件里面的东西
	# 尝试解压    
	res=`7z x "$1" -o"${dir}" -y -p"$a" | grep "Everything"`
	if [  -n "$res" ] ;then
		echo "文件解压 $name 成功"
	return 0
	else
	#删除解压失败的残余
		cd $dir
		for line in $files
		do
			rm -rf ./$line
		done
		return 1
	fi
}

unpackzipfile(){
	dir=`dirname "$1"`
	name=`basename "$1"`
	echo "解压文件：$name  解压目录：$dir"
	trypassds "$1"
	if [ $? = 0 ];then
		echo "解压 $name 成功"
		if [ $delete = 1 ];then
			rm "$1"
			echo "      删除文件 $1 成功"
		fi
	return 0
	else        
		for line in `cat $cur/passwds.txt`
		do
			trypassds "$1" "$line"
			if [ $? = 0 ];then
				echo "解压 $name 大成功！"
				if [ $delete = 1 ];then
					rm "$1"
					echo "删除文件 $1 成功"
				fi
				return 0
			fi
		done
		echo "解压 $name 失败"
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
		unpackzipfile "$1"
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

echo "开始解压"
unpackall "$1"
