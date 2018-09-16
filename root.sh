#!/bin/sh
SCRIPTS=`pwd`
cd ..
HOME=`pwd`
read -p "Do you want to create root infrastructure in $HOME ?: " ANS

if [  "$ANS" != "Y" -a "$ANS" != "y" ];then
 exit
fi

# Установлено ли easy-rsa
if [ ! -e /usr/share/easy-rsa ];then
read -p "У вас не установлен пакет easy-rsa без которого , нихуя не выйдет \
Вы хотите установить набор файлов easy-rsa ? y/n: " ans
if [ "$ans" = "Y" -o "$ans" = "y" ];then
                apt install easy-rsa 
        else
		echo "Ну и вали нахуй ослик, еба нахууу бля"
                exit
        fi
fi

# Создание root инфраструктуры
if [ ! -d root ];then
 mkdir root
 cd root
else 
	cd root
fi

if [ ! -d easy-rsa ];then
 cp -r /usr/share/easy-rsa .
 cd easy-rsa
 echo ""
 echo "we must be located in easy-rsa dir"
 pwd
else
	cd easy-rsa
	echo ""
	echo "we must be located in easy-rsa dir"
	pwd
fi

echo ""
echo "#####################################"
echo "Run openssl_vars_edit.sh script..."
 "$SCRIPTS"/openssl_vars_edit.sh `pwd`
echo ""
pwd
echo ""
. ./vars
./clean-all
./build-ca --batch
