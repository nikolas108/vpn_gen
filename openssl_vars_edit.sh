#!/bin/bash
echo ""
pwd
echo "\$1  =  $1"
cat << EOF
Выберите срок жизни сертификата и ключа сервера, по умолчанию 3650 ( рекомендуемо 36500 )
EOF

# for openssl conf file
read EXPIRE
echo "trying to cp openssl-1.0.0.cnf to openssl.cnf..................."
cp openssl-1.0.0.cnf openssl.cnf
# ls -lah .   //for debugging
if [ ! -z "$EXPIRE" ]; then
sed -i "s/default_days.*/default_days = $EXPIRE /g"  "$1"/openssl-0.9.6.cnf
sed -i "s/default_days.*/default_days = $EXPIRE /g"  "$1"/openssl-0.9.8.cnf
sed -i "s/default_days.*/default_days = $EXPIRE /g"  "$1"/openssl-1.0.0.cnf
sed -i "s/default_days.*/default_days = $EXPIRE /g"  "$1"/openssl.cnf
sed -i "s/CA_EXPIRE=3650/CA_EXPIRE=$EXPIRE/g" "$1"/vars
sed -i "s/KEY_EXPIRE=3650/KEY_EXPIRE=$EXPIRE/g" "$1"/vars
fi


# set vars for easy-rsa/vars
echo "Введите параметры сертификата"
grep KEY_COUNTRY vars
grep KEY_PROVINCE vars
grep KEY_CITY vars
grep KEY_ORG vars
grep KEY_EMAIL vars
grep KEY_OU vars
grep KEY_NAME vars

echo -n "KEY_COUNTRY="
read KEY_COUNTRY
if [ ! -z "$KEY_COUNTRY" ];then
echo $KEY_COUNTRY
sed -i "s/KEY_COUNTRY=.*/KEY_COUNTRY=$KEY_COUNTRY/g" "$1"/vars
fi

echo -n "KEY_PROVINCE="
read KEY_PROVINCE
if [ ! -z "$KEY_PROVINCE" ];then
sed -i "s/KEY_PROVINCE=.*/KEY_PROVINCE=$KEY_PROVINCE/g" "$1"/vars
fi

echo -n "KEY_CITY="
read KEY_CITY
if [ ! -z "$KEY_CITY" ];then
sed -i "s/KEY_CITY=.*/KEY_CITY=$KEY_CITY/g" "$1"/vars
fi

echo -n "KEY_ORG="
read KEY_ORG
if [ ! -z "$KEY_ORG" ];then
sed -i "s/KEY_ORG=.*/KEY_ORG=$KEY_ORG/g" "$1"/vars
fi

echo -n "KEY_EMAIL="
read KEY_EMAIL
if [ ! -z "$KEY_EMAIL" ];then
sed -i "s/KEY_EMAIL=.*/KEY_EMAIL=$KEY_EMAIL/g" "$1"/vars
fi

echo -n "KEY_OU="
read KEY_OU
if [ ! -z "$KEY_OU" ];then
sed -i "s/KEY_OU=.*/KEY_OU=$KEY_OU/g" "$1"/vars
fi

echo -n "KEY_NAME="
read KEY_NAME
if [ ! -z "$KEY_NAME" ];then
sed -i "s/KEY_NAME=.*/KEY_NAME=$KEY_NAME/g" "$1"/vars
fi

# set encryption /
echo "Set encryption alghoritm. Yealink can work with md5 or sha-1. Recomend to use SHA1."
echo "If you set VPN server for BRIA or VPN network for linux servers , use sha256"
echo -n "chose 1 or 2,1-yealink; 2-other configuration.:"
read ALGENCRYPT

if [ $ALGENCRYPT = "1" ];then
echo "you chose 1, YEALINK"
sed -i "s/default_md.*/default_md = md5/g" "$1"/openssl-0.9.6.cnf
sed -i "s/default_md.*/default_md = md5/g" "$1"/openssl-0.9.8.cnf
sed -i "s/default_md.*/default_md = md5/g" "$1"/openssl-1.0.0.cnf
sed -i "s/default_md.*/default_md = md5/g" "$1"/openssl.cnf
export ALGENCRYPT
else
echo "you chose 2, bria or just vpn network"
sed -i "s/default_md.*/default_md = sha256/g" "$1"/openssl-0.9.6.cnf
sed -i "s/default_md.*/default_md = sha256/g" "$1"/openssl-0.9.8.cnf
sed -i "s/default_md.*/default_md = sha256/g" "$1"/openssl-1.0.0.cnf
sed -i "s/default_md.*/default_md = sha256/g" "$1"/openssl.cnf
export ALGENCRYPT
fi

sed -i "s/\$NODES_P12 )/\$NODES_P12 -passout pass:qwert123 )/g" "$1"/pkitool

#sed '/KEY_SIZE/d' -i /etc/openvpn/$dir/easy-rsa/vars
#sed '52a\export KEY_SIZE=2048\' -i /etc/openvpn/$dir/easy-rsa/vars
