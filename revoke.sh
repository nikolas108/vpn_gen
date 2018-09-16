#!/bin/bash

# Отзыв сертификата
SCRIPT_DIR=`pwd`
cd ..
HOME=`pwd`
if [ $# = 0 ];then
	echo "У вас установлена такая вот VPN инфраструктура"
	echo "Чтобы отозвать сертификать запустите скрипт с тремя параметрами VM SRV NUMBER"
	for VM in `cat $HOME/vms`
		do
			echo "$VM"
			for SRV in `cat $HOME/$VM/srv`
				do
					echo -e "\t $SRV"
					while read CL 
						do
							echo -ne "\t\t "
							echo $CL | sed -e 's/\(^.\).*\(CN=.*\/\)\(name.*\)/\2   \1/g' -e 's/[CN=|\/]//g' 
						done < $HOME/$VM/$SRV/easy-rsa/keys/index.txt
				done
		done

fi 

if [ $# = 3 ];then
	VM=$1
	SRV=$2
	CLIENT=$3
	cd $VM/$SRV/easy-rsa
	. ./vars
	./revoke-full $CLIENT
	sed -e 's/\(^.\).*\(CN=.*\/\)\(name.*\)/\2   \1/g' -e 's/[CN=|\/]//g' keys/index.txt | grep $CLIENT

	read -p " Вы хотите синхронизировать сделанные изменения с рабочим сервером ?: " ans
	if [[ $ans =~ [yY] ]];then
		cd $SCRIPT_DIR
		./sync.sh $VM $SRV
	
	else
		echo "good BYE"
	fi
fi					
			 

