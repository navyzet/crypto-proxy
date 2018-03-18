#!/bin/bash

if [ -z "$1" ]
  then
    echo "Используйте: ./config.sh namesite.ru"
    exit 1
fi

SITE=$1

# Установка корневого сертификата тестового сервера сертификации
certmgr -inst -store uroot -file /root/crypto_pro_test_center_2_root.cer

#Запрос ключа сервера
cryptcp -creatcert -provtype 75 -provname "Crypto-Pro GOST R 34.10-2001 KC1 CSP" -rdn "CN=${SITE}" -cont '\\.\HDIMAGE\container' -certusage 1.3.6.1.5.5.7.3.1 -ku -du -ex -ca http://cryptopro.ru/certsrv

#Разрешить крипровайдер  KC2
certmgr -inst -store uMy -cont '\\.\HDIMAGE\container' -provtype 75 -provname "Crypto-Pro GOST R 34.10-2001 KC2 CSP"
#Импорт сертификата для nginx
certmgr -export -store uMy -dest /etc/nginx/mycert.cer
openssl x509 -inform DER -outform PEM -in /etc/nginx/mycert.cer -out /etc/nginx/mycert.cer.pem

# Настройка nginx
cp /root/nginx_site.conf  /etc/nginx/sites-enabled/${SITE}
sed -i "s/SITE/${SITE}/" /etc/nginx/sites-enabled/${SITE}
sed -i "s/www-data/root/" /etc/nginx/nginx.conf
rm -f /etc/nginx/sites-enabled/default
/etc/init.d/nginx reload
