#!/bin/sh
HOME=`pwd`/..
CONFIG_DIR="$1"
CONFIG_NAME="$2"
SRV_NAME="$3"

if [ "$#" != "3" ];then
	echo "use gen_srv_conf.sh CONFIG_DIR CONFIG_NAME SRV_NAME"
	exit
fi

echo "VPN Network configure,lets start."
#echo "The name of config file will be $CONF_NAME.conf or you can chose another name"
cd "$CONFIG_DIR" 
cat << EOF > $CONFIG_NAME
#################################################
# Sample OpenVPN 2.0 config file for            #
# multi-client server.                          #
#                                               #
# This file is for the server side              #
# of a many-clients <-> one-server              #
# OpenVPN configuration.                        #
#                                               #
# OpenVPN also supports                         #
# single-machine <-> single-machine             #
# configurations (See the Examples page         #
# on the web site for more info).               #
#                                               #
# This config should work on Windows            #
# or Linux/BSD systems.  Remember on            #
# Windows to quote pathnames and use            #
# double backslashes, e.g.:                     #
# "C:\\Program Files\\OpenVPN\\config\\foo.key" #
#                                               #
# Comments are preceded with '#' or ';'         #
#################################################

EOF

echo "Define next network parameter port|proto|dev:"
echo " You current net config: "

#look at current configuration
ip a | grep inet
iptables -L -nv
netstat -anptu

#set port
echo -n " Port Number: "
read PORT
#set proto
echo -n "Chose protocol for openvpn, type 1 for tcp, default udp: "
read PROTO
if [ "$PROTO" = "1" ];then
  PROTO=tcp
else
 PROTO=udp
fi

#set tun
echo -n " Set tun number: "
read TUN
TUN=tun$TUN

#set CA KEY CERT DH
if [ -z "$1" ];then
	echo -n "Введите имя директории в которой хранятся сертификат корня , сервера , ключ и DH файлы.: "
	read CONFIG_DIR
fi

echo -n " Определите сеть для vpn подключений , например 10.1.0.0 255.255.255.0 : "
read NETWORK
if [ -z $NETWORK ];then
 NETWORK="10.15.0.0 255.255.255.0"
fi
read -p "задйте ip адрес на котором будет слушать openvpn : " LOCAL
export LOCAL
echo $PROTO $PORT $TUN $CONF_DIR $NETWORK $CONFIG_NAME $LOCAL

echo "local $LOCAL" >> "$CONFIG_NAME"
echo "port $PORT" >> "$CONFIG_NAME"
echo "proto $PROTO" >> "$CONFIG_NAME"
echo "dev $TUN" >> "$CONFIG_NAME"
echo "" >> "$CONFIG_NAME"
echo "persist-key" >> "$CONFIG_NAME"
echo "persist-tun" >> "$CONFIG_NAME"
echo "" >> "$CONFIG_NAME"
echo "ca /etc/openvpn/$SRV_NAME/ca.crt" >> "$CONFIG_NAME"
echo "cert /etc/openvpn/$SRV_NAME/$SRV_NAME.crt" >> "$CONFIG_NAME"
echo "key /etc/openvpn/$SRV_NAME/$SRV_NAME.key" >> "$CONFIG_NAME"
echo "dh /etc/openvpn/$SRV_NAME/dh2048.pem" >> "$CONFIG_NAME"
echo "tls-auth /etc/openvpn/$SRV_NAME/ta.key 0" >> "$CONFIG_NAME"
echo "key-direction 0" >> "$CONFIG_NAME"
echo "" >> "$CONFIG_NAME"
echo "server $NETWORK" >> "$CONFIG_NAME"
echo ";push \"route 10.12.0.0 255.255.255.0\"" >> "$CONFIG_NAME"
echo "" >> "$CONFIG_NAME"
echo "client-config-dir /etc/openvpn/$SRV_NAME/ccd" >> "$CONFIG_NAME"
echo "ccd-exclusive" >> "$CONFIG_NAME"
echo "" >> "$CONFIG_NAME"
echo "client-to-client" >> "$CONFIG_NAME"
echo "keepalive 10 60" >> "$CONFIG_NAME"
echo "reneg-sec 86400" >> "$CONFIG_NAME"
echo "" >> "$CONFIG_NAME"
echo "comp-lzo no" >> "$CONFIG_NAME"
echo "verb 3" >> "$CONFIG_NAME"
echo "" >> "$CONFIG_NAME"
echo "crl-verify /etc/openvpn/$SRV_NAME/easy-rsa/keys/crl.pem" >> "$CONFIG_NAME"
echo "ifconfig-pool-persist /etc/openvpn/$SRV_NAME/ipp.txt" >> "$CONFIG_NAME"
echo "status openvpn-status$SRV_NAME.log" >> "$CONFIG_NAME"
echo "log-append /var/log/openvpn/openvpn$SRV_NAME.log" >> "$CONFIG_NAME"
echo "" >> "$CONFIG_NAME"
echo ";max-clients 100" >> "$CONFIG_NAME"
echo ";mute 20" >> "$CONFIG_NAME"
echo ";cipher BF-CBC" >> "$CONFIG_NAME"
echo ";cipher AES-128-CBC" >> "$CONFIG_NAME"
echo ";cipher DES-EDE3-CBC" >> "$CONFIG_NAME"
echo "" >> "$CONFIG_NAME"
echo ";push \"route 192.168.1.0 255.255.255.0\"" >> "$CONFIG_NAME"
echo ";route 192.168.40.128 255.255.255.248" >> "$CONFIG_NAME"


read -p "Do you want to generate clients certs/keys/configs ?(y/n): " ANS
if [ "$ANS" != "y" -a "$ANS" != "Y" ];then
	exit
else
	read -p " Вы вручную введете параметры (номер абонента , зост , название сервера ) -1 или укажите подготовденный файл -2 ?(1/2): " ANS
	case "$ANS" in
		1 ) client_cert_conf.sh -m; break;;
		2 ) client_cert_conf.sh -f; break;;
		* ) echo "Ответ не верный";exit
	esac
fi
