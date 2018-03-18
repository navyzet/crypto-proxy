#!/bin/bash

#Запускаем криптопро при необходимости доустановка kc2
if [[ $(dpkg -l | grep lsb-cprocsp-kc2.* | wc -l) -gt 0 ]]; then
  /etc/init.d/cprocsp start
else
  alien -kci /root/distr/lsb-cprocsp-kc2-64-*.x86_64.rpm
fi

nginx -g 'daemon off;'
