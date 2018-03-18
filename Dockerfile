FROM ubuntu:16.04
ENV PATH="${PATH}:/opt/cprocsp/bin/amd64/:/opt/cprocsp/sbin/amd64/"

#Установка ПО
RUN apt-get update \
    && apt-get install -y software-properties-common --no-install-recommends \
    && apt-add-repository -y ppa:nginx/stable \
    && apt-get update \
    && apt-get install -y nginx             \
                          lsb-base lsb-core \
                          dialog            \
                          libcurl3         \
                          alien --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

#Вывод nginx на stdout
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

#Копировать папку с дистрибутивами
ADD distr /root/distr

# Установка CryptoPro CSP
RUN chmod +x /root/distr/*.sh
RUN /root/distr/install.sh

#Настройка пути к libcurl
RUN cpconfig -ini \config\apppath -add string libcurl.so /usr/lib/x86_64-linux-gnu/libcurl.so.3


#Установка и настройка криптографического движка для openssl
RUN alien -kci  /root/distr/cprocsp-cpopenssl-base-*.noarch.rpm
RUN alien -kci  /root/distr/cprocsp-cpopenssl-64-*.x86_64.rpm
RUN alien -kci  /root/distr/cprocsp-cpopenssl-gost-64-*.x86_64.rpm
COPY openssl.cnf /etc/ssl/

#Копиирование сертификата тестового центра сертификации
COPY crypto_pro_test_center_2_root.cer /root

#Вспомогательные конфиги
COPY nginx_site.conf /root
COPY config.sh /root
RUN chmod +x /root/config.sh

EXPOSE 443

VOLUME ["/sys/fs/cgroup"]
VOLUME ["/run"]

COPY start.sh /root
RUN chmod +x /root/start.sh
CMD ["/root/start.sh"]
