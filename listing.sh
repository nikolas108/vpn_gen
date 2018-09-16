#!/bin/bash

# Отзыв сертификата

cd ..
HOME=`pwd`
if [ $# = 0 ];then
	echo "У вас установлена такая вот VPN инфраструктура"
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
elif [ $# = 1 ];then
	VM=$1
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
elif [ $# = 2 ];then
	VM=$1
	SRV=$2
	echo "$VM"
	echo -e "\t $SRV"
	while read CL
               do
                     echo -ne "\t\t "
                     echo $CL | sed -e 's/\(^.\).*\(CN=.*\/\)\(name.*\)/\2   \1/g' -e 's/[CN=|\/]//g'
               done < $HOME/$VM/$SRV/easy-rsa/keys/index.txt
else
	echo "Неправильно используете параметры ./listing.sh [VM] [SRV]"
fi 
					
			 

