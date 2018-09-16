#!/bin/bash

SCRIPTS=`pwd`
cd ..
HOME=`pwd`
VM="$2"
SRV="$3"
SRV_DIR=""
TYPE="$4"  ##  1-Yealink , 2-iphone , 3- Android , 4-PC 
FILE_NAME="$5"
FILE_DIR=""
FILE=""
NUMBER="$5"
TYPE_NAME=""
CLIENTS_DIR=""
CONFIG_NAME=""
EASYRSA_DIR=""
KEYS_DIR=""
declare -a IP
declare -a PORT
set -x


# gen_cert_conf type 1 - yealinks | stoped
usage()
{
 		echo "usage: client_gen_cert.sh (-f|-a|-s) (VM)  (SRV) (TYPE)  (file|array|ask)"
 		echo "-f names from file"
 		echo "-a names from parameters to script, as array"
 		echo "-s answer the quastion"
 		echo " Second parameter is name of host, to which you want create client certs"
 		echo " Third parameter is VPN server , from which script will use easy-rsa infrastructure"
  exit
}

gen_conf()
{
	##  Gen config file for iphone
	echo "$TYPE $TYPE_NAME $NUMBER function gen_conf() "
	if [ $TYPE_NAME = "iphone" ];then
		touch $CLIENTS_DIR/$NUMBER.ovpn
		CONFIG_NAME=$CLIENTS_DIR/$NUMBER.ovpn
		SRV_DIR=$HOME/$VM/$SRV
#		PORT=`grep port "$SRV_DIR/$SRV.conf" | awk '{print $2}'`
		PROTO=`grep proto "$SRV_DIR/$SRV.conf" | awk '{print $2}'`
		if [ -z $PROTO ];then PROTO="udp";fi
		LOCAL=`grep local "$SRV_DIR/$SRV.conf" | awk '{print $2}'`
		echo "client" > "$CONFIG_NAME"
		echo "proto $PROTO" >> "$CONFIG_NAME"
		echo "dev tun" >> "$CONFIG_NAME"
		for ((i=0;i<${#IP[@]};i++))
			do
				echo "remote ${IP[$i]} ${PORT[$i]}" >> "$CONFIG_NAME"
			done

		echo "" >> "$CONFIG_NAME"
		echo "persist-key" >> "$CONFIG_NAME"
		echo "persist-tun" >> "$CONFIG_NAME"
		echo "nobind" >> "$CONFIG_NAME"
		echo "remote-cert-tls server" >> "$CONFIG_NAME"
		echo "" >> "$CONFIG_NAME"
		echo "key-direction 1" >> "$CONFIG_NAME"
		echo "cipher BF-CBC" >> "$CONFIG_NAME"
		echo "auth SHA256" >> "$CONFIG_NAME"
		echo "" >> "$CONFIG_NAME"
		echo ";tls-version-min 1.2" >> "$CONFIG_NAME"
		echo "resolv-retry infinite" >> "$CONFIG_NAME"
		echo "auth-retry nointeract" >> "$CONFIG_NAME"
		echo "reneg-sec 0" >> "$CONFIG_NAME"
		echo "" >> "$CONFIG_NAME"
		echo "comp-lzo no" >> "$CONFIG_NAME"
		echo "verb 3" >> "$CONFIG_NAME"
		echo "" >> "$CONFIG_NAME"
		echo "<ca>" >> "$CONFIG_NAME"
		cat  $SRV_DIR/ca.crt >> "$CONFIG_NAME"
		echo "</ca>" >> "$CONFIG_NAME"
		echo "" >> "$CONFIG_NAME"
		echo "<tls-auth>" >> "$CONFIG_NAME"
		cat $SRV_DIR/ta.key >> "$CONFIG_NAME"
		echo "</tls-auth>" >> "$CONFIG_NAME"
		
	fi
	if [ $TYPE_NAME = "android" ];then
		touch $CLIENTS_DIR/$NUMBER.ovpn
                CONFIG_NAME=$CLIENTS_DIR/$NUMBER.ovpn
                SRV_DIR=$HOME/$VM/$SRV
                #PORT=`grep port "$SRV_DIR/$SRV.conf" | awk '{print $2}'`
                PROTO=`grep proto "$SRV_DIR/$SRV.conf" | awk '{print $2}'`
		if [ -z $PROTO ];then PROTO="udp";fi
                echo "client" > "$CONFIG_NAME"
                echo "proto $PROTO" >> "$CONFIG_NAME"
                echo "dev tun" >> "$CONFIG_NAME"
		for ((i=0;i<${#IP[@]};++i))
			do
				echo "remote ${IP[$i]} ${PORT[$i]}" >> "$CONFIG_NAME"
			done
                echo "" >> "$CONFIG_NAME"
                echo "persist-key" >> "$CONFIG_NAME"
                echo "persist-tun" >> "$CONFIG_NAME"
                echo "nobind" >> "$CONFIG_NAME"
                echo "remote-cert-tls server" >> "$CONFIG_NAME"
                echo "" >> "$CONFIG_NAME"
                echo "key-direction 1" >> "$CONFIG_NAME"
                echo "cipher BF-CBC" >> "$CONFIG_NAME"
                echo "auth SHA256" >> "$CONFIG_NAME"
                echo "" >> "$CONFIG_NAME"
                echo ";tls-version-min 1.2" >> "$CONFIG_NAME"
                echo "resolv-retry infinite" >> "$CONFIG_NAME"
                echo "auth-retry nointeract" >> "$CONFIG_NAME"
                echo "reneg-sec 0" >> "$CONFIG_NAME"
                echo "" >> "$CONFIG_NAME"
                echo "comp-lzo no" >> "$CONFIG_NAME"
                echo "verb 3" >> "$CONFIG_NAME"
                echo "" >> "$CONFIG_NAME"
                echo "<ca>" >> "$CONFIG_NAME"
                cat  $SRV_DIR/ca.crt >> "$CONFIG_NAME"
                echo "</ca>" >> "$CONFIG_NAME"
                echo "" >> "$CONFIG_NAME"
		echo "<cert>" >> "$CONFIG_NAME"
                sed -n '/BEGIN/,$p' $KEYS_DIR/$NUMBER.crt >> "$CONFIG_NAME"
                echo "</cert>" >> "$CONFIG_NAME"
                echo "" >> "$CONFIG_NAME"
		echo "<key>" >> "$CONFIG_NAME"
                cat  $KEYS_DIR/$NUMBER.key >> "$CONFIG_NAME"
                echo "</key>" >> "$CONFIG_NAME"

                echo "" >> "$CONFIG_NAME"
                echo "<tls-auth>" >> "$CONFIG_NAME"
                cat $SRV_DIR/ta.key >> "$CONFIG_NAME"
                echo "</tls-auth>" >> "$CONFIG_NAME"
	fi	

	if [ $TYPE_NAME = "pc" ];then
		#touch $CLIENTS_DIR/$NUMBER.ovpn
                CONFIG_NAME=$CLIENTS_DIR/$NUMBER.conf
                SRV_DIR=$HOME/$VM/$SRV
                #PORT=`grep port "$SRV_DIR/$SRV.conf" | awk '{print $2}'`
                PROTO=`grep proto "$SRV_DIR/$SRV.conf" | awk '{print $2}'`
		if [ -z $PROTO ];then PROTO="udp";fi
                echo "client" > "$CONFIG_NAME"
                echo "proto $PROTO" >> "$CONFIG_NAME"
                echo "dev tun$TUN" >> "$CONFIG_NAME"
                for ((i=0;i<${#IP[@]};++i))
                        do
                                echo "remote ${IP[$i]} ${PORT[$i]}" >> "$CONFIG_NAME"
                        done
                echo "" >> "$CONFIG_NAME"
                echo "persist-key" >> "$CONFIG_NAME"
                echo "persist-tun" >> "$CONFIG_NAME"
                echo "nobind" >> "$CONFIG_NAME"
                echo "remote-cert-tls server" >> "$CONFIG_NAME"
                echo "" >> "$CONFIG_NAME"
                echo "key-direction 1" >> "$CONFIG_NAME"
                echo "cipher BF-CBC" >> "$CONFIG_NAME"
                echo "auth SHA256" >> "$CONFIG_NAME"
                echo "" >> "$CONFIG_NAME"
                echo ";tls-version-min 1.2" >> "$CONFIG_NAME"
                echo "resolv-retry infinite" >> "$CONFIG_NAME"
                echo "auth-retry nointeract" >> "$CONFIG_NAME"
                echo "reneg-sec 0" >> "$CONFIG_NAME"
                echo "" >> "$CONFIG_NAME"
                echo "comp-lzo no" >> "$CONFIG_NAME"
                echo "verb 3" >> "$CONFIG_NAME"
                echo "" >> "$CONFIG_NAME"
                echo "<ca>" >> "$CONFIG_NAME"
                cat  $SRV_DIR/ca.crt >> "$CONFIG_NAME"
                echo "</ca>" >> "$CONFIG_NAME"
                echo "" >> "$CONFIG_NAME"
		echo "<cert>" >> "$CONFIG_NAME"
                sed -n '/BEGIN/,$p' $KEYS_DIR/$NUMBER.crt >> "$CONFIG_NAME"
                echo "</cert>" >> "$CONFIG_NAME"
                echo "" >> "$CONFIG_NAME"
		echo "<key>" >> "$CONFIG_NAME"
                cat  $KEYS_DIR/$NUMBER.key >> "$CONFIG_NAME"
                echo "</key>" >> "$CONFIG_NAME"

                echo "" >> "$CONFIG_NAME"

                echo "<tls-auth>" >> "$CONFIG_NAME"
                cat $SRV_DIR/ta.key >> "$CONFIG_NAME"
                echo "</tls-auth>" >> "$CONFIG_NAME"
        fi
	
}

gen_cert_conf()
{
#awk  '{if ($1 == "default_md") { print $3;} }' openssl*
	echo "exec gen_cert_conf here!!!!!!!!!!!!"
	echo "\$HOME=$HOME \$SCRIPTS=$SCRIPTS \$VM=$VM \$SRV=$SRV \$TYPE=$TYPE \$FILE=$FILE"
	echo " Parameters  1234 $1 $2 $3 $4 $TYPE_NAME "
	CLIENTS_DIR=$HOME/$VM/$SRV/clients/$TYPE_NAME
	EASYRSA_DIR=$HOME/$VM/$SRV/easy-rsa
	KEYS_DIR=$EASYRSA_DIR/keys
	if [ $TYPE = 2 -o "$TYPE" = "i" ];then
	  if [ ! -e $EASYRSA_DIR/keys/$NUMBER.p12 ];then
		cd $EASYRSA_DIR 
		. ./vars
		$EASYRSA_DIR/build-key-pkcs12 --batch $NUMBER
		cp $KEYS_DIR/$NUMBER.p12 $CLIENTS_DIR/$NUMBER.ovpn12
		touch $HOME/$VM/$SRV/ccd/$NUMBER
		gen_conf $TYPE $NUMBER
	  else 
		cp $KEYS_DIR/$NUMBER.p12 $CLIENTS_DIR/$NUMBER.ovpn12
		touch $HOME/$VM/$SRV/ccd/$NUMBER
                gen_conf $TYPE $NUMBER
	  fi
	fi
	
	if [ $TYPE = 1 -o "$TYPE" = "y" ];then
		echo "exec gen_cert_conf here!!!!!!!!!!!!"
		echo "\$HOME=$HOME \$SCRIPTS=$SCRIPTS \$VM=$VM \$SRV=$SRV \$TYPE=$TYPE \$FILE=$FILE"
		echo " Parameters  1234 $1 $2 $3 $4 $TYPE_NAME "
		echo "you chose $TYPE we have no cmd for thith choice yet"
		touch $HOME/$VM/$SRV/ccd/$NUMBER
		if [ ! -e $EASYRSA_DIR/keys/$NUMBER.key -o ! -e $EASYRSA_DIR/keys/$NUMBER.crt ];then
                	cd $EASYRSA_DIR && . ./vars
	                $EASYRSA_DIR/build-key --batch $NUMBER
			mkdir $CLIENTS_DIR/$NUMBER
			cp -r $CLIENTS_DIR/keys $CLIENTS_DIR/vpn.cnf $CLIENTS_DIR/$NUMBER
			cp $KEYS_DIR/$NUMBER.key $SRV_DIR/ca.crt $SRV_DIR/ta.key $KEYS_DIR/$NUMBER.crt $CLIENTS_DIR/$NUMBER/keys
			sed -i "s/template108/$NUMBER/g"  $CLIENTS_DIR/$NUMBER/vpn.cnf
			g=16
			for ((i=0;i<${#IP[@]};++i))
				do 
					sed -i "${g}iremote ${IP[$i]} ${PORT[$i]}" $CLIENTS_DIR/$NUMBER/vpn.cnf
					let g=$g+1
				done	

                        cd $CLIENTS_DIR/$NUMBER && tar cf $NUMBER.tar  vpn.cnf keys
			mv $NUMBER.tar .. && cd ..
			rm -r $CLIENTS_DIR/$NUMBER
          	else
			mkdir $CLIENTS_DIR/$NUMBER
                        cp -r $CLIENTS_DIR/keys $CLIENTS_DIR/vpn.cnf $CLIENTS_DIR/$NUMBER
			cp $KEYS_DIR/$NUMBER.key $SRV_DIR/ca.crt $SRV_DIR/ta.key $KEYS_DIR/$NUMBER.crt $CLIENTS_DIR/$NUMBER/keys
                        sed -i "s/template108/$NUMBER/g"  $CLIENTS_DIR/$NUMBER/vpn.cnf
			g=16
			for ((i=0;i<${#IP[@]};++i))
				do 
					sed -i "${g}iremote ${IP[$i]} ${PORT[$i]}" $CLIENTS_DIR/$NUMBER/vpn.cnf
					let g=$g+1
					#echo "remote ${IP[$i]} ${PORT[$i]}" >> $CLIENTS_DIR/$NUMBER/vpn.cnf
				done	
                        cd $CLIENTS_DIR/$NUMBER && tar cf $NUMBER.tar  vpn.cnf keys
			mv $NUMBER.tar .. && cd ..
                        rm -r $CLIENTS_DIR/$NUMBER                	
          	fi
	fi
	
	if [ $TYPE = 3 -o "$TYPE" = "a" -o $TYPE = 4 -o  "$TYPE" = "p" ];then
		echo "exec gen_cert_conf here!!!!!!!!!!!!"
                echo "\$HOME=$HOME \$SCRIPTS=$SCRIPTS \$VM=$VM \$SRV=$SRV \$TYPE=$TYPE \$FILE=$FILE"
                echo " Parameters  1234 $1 $2 $3 $4 $TYPE_NAME "
                echo "you chose $TYPE we have no cmd for thith choice yet"	
		if [ ! -e $EASYRSA_DIR/keys/$NUMBER.key -o ! -e $EASYRSA_DIR/keys/$NUMBER.crt ];then
                        cd $EASYRSA_DIR && . ./vars
                        $EASYRSA_DIR/build-key --batch $NUMBER
                        #touch $CLIENTS_DIR/$NUMBER.conf
			gen_conf $TYPE $NUMBER 
                else
                	#touch $CLIENTS_DIR/$NUMBER.conf
                        gen_conf $TYPE $NUMBER
		fi


	fi
	
		

}


if [ $# = 1 -a "$1" = "-m" ];then   ###  -m 1кусок
   while true; do
	echo "#####------------------------1 вариант -----------------------"
	echo "Все параметры вводятся ручками"
	ls -lah "$HOME" | awk '{print $9}' | grep -v '\(root\|scripts\|templates\|vms\|\.rnd\)'   ## CHOSE VM
	cat "$HOME"/vms
	read -p "Выберете хост для которого вы хотите создать клиента: " VM
	cat "$HOME"/"$VM"/srv									## CHOSE SRV
	ls -lah "$HOME"/"$VM"
	read -p "Введите номер VPN cервера  : " SRV
	if [ ! -d "$VM"/"$SRV" ];then
		echo "Директория $VM/$SRV не существет , попробуйте еще раз"
		continue
	fi
	echo "Для какого устройства хотите создать конфигурационный файл " 
	while true; do
		read -p "1-yealink , 2-iphone , 3- android , 4-pc, 5-mac или 1ю букву y|i|a|p|m  : " TYPE  ## CHOSE TYPE
		case $TYPE in
			[y1] ) TYPE_NAME="yealink";break;;
			[i2] ) TYPE_NAME="iphone";break;;
			[a3] ) TYPE_NAME="android";break;;
			[p4] ) TYPE_NAME="pc";break;;
			[m5] ) TYPE_NAME="mac";break;;
			* ) continue;;
		esac
	done
	read -p "Введите номер абонента : " NUMBER  ###  NUMBER
	ind=0
	echo " Введите ip адреса и порт VPN серверов к которым будут подключаться VPN клиенты"
	while read ip;do
		if [ "$ip" = "stop" ];then
			break
		fi
		IP[$ind]=$ip
		read -p " номер порта : " port
		PORT[$ind]=$port
		echo "${IP[$ind]} ${PORT[$ind]}"
		ind=`expr $ind + 1`
	done
	
	if [ $TYPE_NAME = "pc" ];then
		read -p "Введите номер интерфейса. Если конфиг для windows системы, нажмите enter" TUN
	fi
	
	read -p "Вы выбрали VM=$VM , vpn_server=$SRV , номер = $NUMBER, для $TYPE_NAME устройства верно?: " ANS
	if [ $ANS = "y" -o $ANS = "Y" ];then 
	 break
	else
	 continue
	fi
   done
  SRV_DIR=$HOME/$VM/$SRV
  gen_cert_conf $VM $SRV $TYPE $NUMBER

## start sector with 5 parameters and 1num
elif [ $# = 5 -a "$1" = "-m" ];then
	echo "###----------------IF -m 5ть параметров --------------"
	if [ ! -d "$VM"/"$SRV" ];then
                echo "Директория $VM/$SRV не существет , попробуйте еще раз (1й elif -m 5ть параметров exit) "
                exit
        fi
		case $TYPE in
			[y1] ) TYPE_NAME="yealink";break;;
			[i2] ) TYPE_NAME="iphone";break;;
			[a3] ) TYPE_NAME="android";break;;
			[p4] ) TYPE_NAME="pc";break;;
			[m5] ) TYPE_NAME="mac";break;;
			* ) continue;;
		esac
	ind=0
	echo " Введите ip адреса и порт VPN серверов к которым будут подключаться VPN клиенты"
	while read ip;do
		if [ "$ip" = "stop" ];then
			break
		fi
		IP[$ind]=$ip  
		read -p " номер порта : " port
		PORT[$ind]=$port
		echo "${IP[$ind]} ${PORT[$ind]}"
		ind=`expr $ind + 1`
	done
	
	if [ $TYPE_NAME = "pc" ];then
		read -p "Введите номер интерфейса. Если конфиг для windows системы, нажмите enter" TUN
	fi

	read -p "Вы выбрали VM=$VM , vpn_server=$SRV , номер = $NUMBER, для $TYPE_NAME устройства верно?: " ANS
	if [ $ANS = "y" -o $ANS = "Y" ];then 
	 break
	else
	 continue
	fi
     	SRV_DIR=$HOME/$VM/$SRV
	gen_cert_conf $VM $SRV $TYPE $NUMBER
## END sector with 5 parameters and 1num

## START sector with 2 parameter -f FILE	
elif [ $# = 2 -a "$1" = "-f" ];then   ###  -f 1кусок
    FILE=$2
    if [ -e $FILE ];then
	cat $FILE
	read -p "Верный файл ? " a
	if [ "$a" = "no" -o "$a" = "n" ];then
		exit
	fi
    elif [ -e $SCRIPTS/$FILE ];then
		FILE=$SCRIPTS/$FILE            
		cat $FILE
	        read -p "Верный файл ? " a
		if [ "$a" = "no" -o "$a" = "n" ];then
                	exit
        	fi
    else	 
       		echo "Файл $FILE не существет ,создайте файл с номерами в папке scripts и попробуйте еще раз (exit) "
                exit
    fi

   while true; do
        echo "#####------------------------1 вариант -----------------------"
        echo "Все параметры вводятся ручками"
        ls -lah "$HOME" | awk '{print $9}' | grep -v '\(root\|scripts\|templates\|vms\|\.rnd\)'
        cat "$HOME"/vms
        read -p "Выберете хост для которого вы хотите создать клиента: " VM
        cat "$HOME"/"$VM"/srv
        ls -lah "$HOME"/"$VM"
        read -p "Введите номер VPN cервера  : " SRV
        if [ ! -d "$VM"/"$SRV" ];then
                echo "Директория $VM/$SRV не существет , попробуйте еще раз"
                continue
        fi
        echo "Для какого устройства хотите создать конфигурационный файл "
        while true; do
                read -p "1-yealink , 2-iphone , 3- android , 4-pc, 5-mac или 1ю букву y|i|a|p|m  : " TYPE
                case $TYPE in
                        [y1] ) TYPE_NAME="yealink";break;;
                        [i2] ) TYPE_NAME="iphone";break;;
                        [a3] ) TYPE_NAME="android";break;;
                        [p4] ) TYPE_NAME="pc";break;;
                        [m5] ) TYPE_NAME="mac";break;;
                        * ) continue;;
                esac
        done

	if [ $TYPE_NAME = "pc" ];then
		read -p "Введите номер интерфейса. Если конфиг для windows системы, нажмите enter" TUN
	fi


        read -p "Вы выбрали VM=$VM , vpn_server=$SRV , для $TYPE_NAME устройства верно?: " ANS
        if [ $ANS = "y" -o $ANS = "Y" ];then
         break
        else
         continue
        fi
   done
	ind=0
	echo " Введите ip адреса и порт VPN серверов к которым будут подключаться VPN клиенты"
	while read ip;do
		if [ "$ip" = "stop" ];then
			break
		fi
		IP[$ind]=$ip
		read -p " номер порта : " port
		PORT[$ind]=$port
		echo "${IP[$ind]} ${PORT[$ind]}"
		ind=`expr $ind + 1`
	done

	read -p "Вы выбрали VM=$VM , vpn_server=$SRV , номер = $NUMBER, для $TYPE_NAME устройства, удаленные сервера ${IP[@]} и порты ${PORT[@]} верно?: " ANS
	if [ $ANS = "y" -o $ANS = "Y" ];then 
	 break
	else
	 continue
	fi

	SRV_DIR=$HOME/$VM/$SRV
        echo "читаем построчно из файла..."
        while read NUMBER;do
		[ ! -z $NUMBER ] && gen_cert_conf $VM $SRV $TYPE $NUMBER
        done < "$FILE"
## END sector with 2 parameter -f FILE

## START sector with 5 parameters -f
elif [ $# = 5 -a "$1" = "-f" ];then
	FILE=$5
        if [ -e $FILE ];then
        	cat $FILE
        	read -p "Верный файл ? " a

	elif [ -e $SCRIPTS/$FILE ];then
                FILE=$SCRIPTS/$FILE
                cat $FILE
                read -p "Верный файл ? " a
	else
                echo "Файл $FILE не существет ,создайте файл с номерами в папке scripts и попробуйте еще раз (exit) "
                exit
	fi

        if [ ! -d $HOME/$VM/$SRV ];then
                echo "Директория $VM/$SRV не существет , попробуйте еще раз (1й elif -m 5ть параметров exit) "
                exit
        fi

	if [ ! -e "$FILE" ];then
                echo "Файл $FILE не существет ,создайте файл с номерами в папке scripts и попробуйте еще раз (exit) "
                exit
        fi
	case $TYPE in
			[y1] ) TYPE_NAME="yealink";break;;
			[i2] ) TYPE_NAME="iphone";break;;
			[a3] ) TYPE_NAME="android";break;;
			[p4] ) TYPE_NAME="pc";break;;
			[m5] ) TYPE_NAME="mac";break;;
			* ) continue;;
		esac
	ind=0

	if [ $TYPE_NAME = "pc" ];then
		read -p "Введите номер интерфейса. Если конфиг для windows системы, нажмите enter" TUN
	fi

	echo " Введите ip адреса и порт VPN серверов к которым будут подключаться VPN клиенты"
	while read ip;do
		if [ "$ip" = "stop" ];then
			break
		fi
		IP[$ind]=$ip
		read -p " номер порта : " port
		PORT[$ind]=$port
		echo "${IP[$ind]} ${PORT[$ind]}"
		ind=`expr $ind + 1`
	done

	SRV_DIR=$HOME/$VM/$SRV
	echo "читаем построчно из файла..."
	while read NUMBER;do
	   [ ! -z $NUMBER ] && gen_cert_conf $VM $SRV $TYPE $NUMBER
	done < "$FILE"

## END sector with 5 parameters -f

else
	usage
fi

echo "HAPPY END"
#if [ $# = "4" -o $# -gt "4" ];then
#   case $1 in
#         "-f" ) gen_cert_file "$VM" "$SRV" "$FILE_NAME";break;;
#         "-a" ) gen_cert_arr "$VM" "$SRV" "$@";break;;
#         "-m" ) gen_cert_manual;break;;
#         * ) usage
#   esac
#fi
#




