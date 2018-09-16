#!/bin/bash
SCRIPTS_DIR=`pwd`
if [ "$1" = "-m" ];then
	if [ $# = 3 ];then
		VM=$2
		DEST=$3
		rsync -avPu --exclude-from 'exclude' --progress '-e ssh' ../$VM/ $DEST
	# exclude = ca.key, vms, srv
	elif [ $# = 4 ];then
		VM=$2
		SRV=$3
		DEST=$4
		rsync -avPu --exclude-from 'exclude' --progress '-e ssh' ../$VM/$SRV ../$VM/$SRV.conf $DEST
	else
		echo "Неправильные параметры , FUCK YOU BITCH ! "
	fi
fi

echo "-z $#"
if [ $# = 0 ];then  # Синхронизация всей инфраструктуры
	./listing.sh
	read -p "Do you want to sync ALL infrastructure ?: " ans
	if [ $ans = "y" -o $ans = "Y" ];then
		for i in `cat ../vms`
			do
				rsync -avPu  --exclude-from 'exclude' --progress '-e ssh' ../$i/ $i:/etc/openvpn
			#	rsync -avPu --exclude='keys/*.key' --exclude-from 'exclude' --progress '-e ssh' ../$i/ $i:/etc/openvpn
				ssh $i 'service openvpn restart'
			done 	
	fi
fi

echo "$#=1"
if [ $# = 1 ];then   # Синхронизация хоста
	rsync -avPu --exclude-from 'exclude' --progress '-e ssh' ../$1/ $1:/etc/openvpn
	ssh $1 'service openvpn restart'
fi

echo "$#=2"   #  Синхронизация сервера , для заданного хоста
if [ $# = 2 ];then
	rsync -avPu --exclude-from 'exclude' --progress '-e ssh' ../$1/$2 ../$1/$2.conf $1:/etc/openvpn
fi


