#!/bin/sh
if [ $# -eq 0 ];then
  echo "true"; SCRIPTS=`pwd`; cd .. ; pwd; echo "$SCRIPTS"  
else
  echo "false"; SCRIPTS="$1"/scripts ; cd "$1" ; echo "$SCRIPTS" 
fi
HOME=`pwd`
ROOT_DIR="$HOME"/root
ROOT_MD5="$HOME"/root_md5
VM_DIR=""
SRV_DIR=""
SRV=""
cat << EOF
The vpn_infrastructure will generate tree of folders
./
  root/
	easy-rsa/key/ca.crt
		     ca.key
  VM1/
      srv1/
	   easy-rsa/key/ca.crt
			ca.key
			srv1.crt
			srv1.key
			dh2048.pem
			ta.key
			crl.pem
	   srv1.conf
	   
	.
	.
	srvn
  .
  .
  VMn/
	srv1...
  
  templates/   # здесь шаблоны для создания конфигов клиентов
	    android
	    iOS
	    yealinks
	    pc
  scripts
	client_create.sh # создание серта/ключа/конфига клиента для yealink|android|iOS
	gen_srv_conf.sh # сгенерить конфиг для сервера
	info  # как пользоваться набором скриптов
	openssl_vars_edit.sh  # изменение параметров в таких файлах как openssl.cnf|vars
	root.sh  # сооздание удостоверяющего центра
	server_create.sh  # создание ключа/серта и конфига для сервера ВПН
  vms  #hosts from ssh_config,with which it will syncronized.
EOF

# проверяем наличие root мнфраструктуры
pwd
echo "\$HOME=$HOME  \$ROOT_DIR=$ROOT_DIR \$SCRIPTS=$SCRIPTS"
if [ ! -d root ];then
   echo "You have no root infra in current dir, copy this scripts to folder with root infra , and try again or create it (exec root.sh)"
   exit
fi

# выбираем сервер для которого создаем сертификаты
grep "Host " /etc/ssh/ssh_config
echo -n "Chose VM name from the listing below. It must be identical like in ssh_config file , and will use to syncronize: "
read VM
###### 1
#read -p "1. \$VM = $VM , is it right ?: " ANS
#if [ "$ANS" != "Y" -a "$ANS" != "y" ];then
#  exit
#fi
# 2
# создаем каталоги под конкретный сервер 
echo "2. ...------------------------------------------------------------------"
VMS=`grep $VM vms`
if [ -z "$VMS" ];then
          echo "$VM" >> "$HOME"/vms
fi

if [ ! -d $VM ];then
  mkdir "$HOME"/"$VM"
fi

cd "$VM"

if [ ! -e srv ];then
	touch srv
fi

echo "должны быть в VM DIR"
pwd
 
VM_DIR=`pwd`

# 3.
# выбираем имя для vpn сервера, и переопределяем переменные в easy-rsa
echo "3. --------------------------------------------------------------"
cat << EOF
Скрипт по созданию VPN сервера,
Необходимо ответить на несколько вопросов.

1) В какой папке хранить настройки сервера ?????????
EOF

read SRV

SERV=`grep $SRV srv`   #  log создания сервера VPN Для данной VM
if [ -z "$SERV" ];then
	echo "$SRV" >> $HOME/$VM/srv
fi


echo -n "You want create VPN server with \$SRV = $SRV name for \$VM = $VM host, is it right?(Y|n): "
read ANS
if [ "$ANS" != "Y" -a "$ANS" != "y" ];then
 exit
fi

# создаем папку для хранения файлов под заданный VPN сервер
mkdir "$SRV" && cd "$SRV" 
SRV_DIR=`pwd`
export VM_DIR VM SRV SRV_DIR

# надо ли менять переменные yealink or linux|bria
echo -n "!!!!!!!!    Do you want to change openssl|vars|pkitool?(Y|N): !!!!!!!!!!!!!!!!!!!!!!               !!!!!!!!!!!!!!!!!  "
read ANS
if [ "$ANS" = "Y" -o "$ANS" = "y" ];then
# 4.
	echo "4. ------------------------------------------------------------------"
  echo " контрольная точа. \$SRV_DIR = $SRV_DIR и находимся мы в..."
  pwd
  echo $ROOT_MD5
  cp -r "$ROOT_MD5"/easy-rsa . && cd easy-rsa
  pwd
  echo "должны находиться в VM/SRV/easy-rsa"
  "$SCRIPTS"/openssl_vars_edit.sh "$SRV_DIR"/easy-rsa
  ALGENCRYPT=1
  echo $ALGENCRYPT ALGENCRYPT
else
  # 4.
  echo "4. ------------------------------------------------------------------"
  echo " контрольная точа. \$SRV_DIR = $SRV_DIR и находимся мы в..."
  pwd
  cp -r "$ROOT_DIR"/easy-rsa . && cd easy-rsa
  pwd
  echo "должны находиться в VM/SRV/easy-rsa"
  ALGENCRYPT=2
  echo $ALGENCRYPT ALGENCRYPT
fi

  echo $ALGENCRYPT ALGENCRYPT
mkdir "$SRV_DIR"/clients
if [ "$ALGENCRYPT" = "1" ];then
	echo $ALGENCRYPT
	cp -r $HOME/templates/yealink $SRV_DIR/clients
else
	echo $ALGENCRYPT
	cp -r "$HOME"/templates/* "$SRV_DIR"/clients
	rm -r $SRV_DIR/client/yealink
fi
# 5.
echo "5. --------------------------------------------------------------------"
pwd
. ./vars
#./clean-all
./build-key-server --batch "$SRV"
./build-dh
openvpn --genkey --secret "$SRV_DIR"/ta.key
./build-key --batch fake1 
./revoke-full fake1
cd keys
cp "$SRV".crt "$SRV".key ca.crt dh2048.pem "$SRV_DIR"

if [ "$ALGENCRYPT" = "1" ];then
	cp  ca.crt $SRV_DIR/ta.key $SRV_DIR/clients/yealink/keys
fi

mkdir "$SRV_DIR"/ccd 
cd "$SRV_DIR"
cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz .
gzip -d server.conf.gz
mv server.conf ../"$SRV".conf

"$SCRIPTS"/gen_srv_conf.sh "$SRV_DIR" ../"$SRV".conf "$SRV"

##  NEXT syncronize to host..




























































