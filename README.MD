Необходимо скачать и распаковать дистрибутив c тестовой лицензией ["КриптоПро CSP"](https://www.cryptopro.ru/products/csp/downloads) в папку distr. Для этого необходима регистрация на сайте.
Сборка тестировалась на дистрибутиве "КриптоПро CSP 4.0 для Linux (x86, rpm)"

Сборка образа: 
```bash
docker build -t crypto .
```

Запуск контейнера: 
```bash
docker run -d --name crypto-nginx --privileged --security-opt seccomp=unconfined --tmpfs /run --tmpfs /run/lock -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 443:443 -t crypto
```

Получение тестового сертификата для сервера (test.ru заменить на имя сайта).  При запросе пароля для криптоконтейнера ввести пустой пароль:
```bash
docker exec -ti crypto-nginx /root/config.sh test.ru
```

Пример вывода: 
```bash
root@ubuntu-2gb-nbg1-dc3-1 ~/crypto-proxy # docker exec -ti crypto-nginx /root/config.sh navyzet.ru
CryptCP 4.0 (c) "Crypto-Pro", 2002-2015.
Command prompt Utility for file signature and encryption.
Creating request...
CPCSP: Signing with the use of GOST R 34.10-2001 keys is not allowed from January 1st, 2019. We highly recommend to move to the use of GOST R 34.10-2012 keys in advance. Continue with the GOST R 34.10-2001 key generation?
(o) OK, (c) Cancel
o
Press keys...
[..........................................................................]

CryptoPro CSP: Set password on produced container "container".
Password:
Retype password:
Passwords are not equal!
Password:
Retype password:
Sending request to CA...
Installing certificate...
Certificate is installed.
[ReturnCode: 0]
Certmgr 1.0 (c) "CryptoPro",  2007-2010.
program for managing certificates, CRLs and stores

Install:
=============================================================================
1-------
Issuer              : E=support@cryptopro.ru, C=RU, L=Moscow, O=CRYPTO-PRO LLC, CN=CRYPTO-PRO Test Center 2
Subject             : CN=navyzet.ru
Serial              : 0x12002667752E825729E3CF803A000000266775
SHA1 Hash           : 0x9e8c54c44ad16152ab55a59275a3dd01ef31143f
SubjKeyID           : 80b4d87101a23e4050fb67a12f6ed72c424969c8
Signature Algorithm : ГОСТ Р 34.11/34.10-2001
PublicKey Algorithm : ГОСТ Р 34.10-2001 (512 bits)
Not valid before    : 05/03/2018  15:15:32 UTC
Not valid after     : 05/06/2018  15:25:32 UTC
PrivateKey Link     : No
CA cert URL         : http://testca.cryptopro.ru/CertEnroll/test-ca-2014_CRYPTO-PRO%20Test%20Center%202.crt
OCSP URL            : http://testca.cryptopro.ru/ocsp/ocsp.srf
CDP                 : http://testca.cryptopro.ru/CertEnroll/CRYPTO-PRO%20Test%20Center%202.crl
Extended Key Usage  : 1.3.6.1.5.5.7.3.1
=============================================================================

[ErrorCode: 0x00000000]
Certmgr 1.0 (c) "CryptoPro",  2007-2010.
program for managing certificates, CRLs and stores

Exporting:
=============================================================================
1-------
Issuer              : E=support@cryptopro.ru, C=RU, L=Moscow, O=CRYPTO-PRO LLC, CN=CRYPTO-PRO Test Center 2
Subject             : CN=navyzet.ru
Serial              : 0x12002667752E825729E3CF803A000000266775
SHA1 Hash           : 0x9e8c54c44ad16152ab55a59275a3dd01ef31143f
SubjKeyID           : 80b4d87101a23e4050fb67a12f6ed72c424969c8
Signature Algorithm : ГОСТ Р 34.11/34.10-2001
PublicKey Algorithm : ГОСТ Р 34.10-2001 (512 bits)
Not valid before    : 05/03/2018  15:15:32 UTC
Not valid after     : 05/06/2018  15:25:32 UTC
PrivateKey Link     : Yes
Container           : HDIMAGE\\containe.000\1514
Provider Name       : Crypto-Pro GOST R 34.10-2001 KC2 CSP
Provider Info       : ProvType: 75, KeySpec: 1, Flags: 0x0
CA cert URL         : http://testca.cryptopro.ru/CertEnroll/test-ca-2014_CRYPTO-PRO%20Test%20Center%202.crt
OCSP URL            : http://testca.cryptopro.ru/ocsp/ocsp.srf
CDP                 : http://testca.cryptopro.ru/CertEnroll/CRYPTO-PRO%20Test%20Center%202.crl
Extended Key Usage  : 1.3.6.1.5.5.7.3.1
=============================================================================
Export complete

[ErrorCode: 0x00000000]
openssl: /opt/cprocsp/cp-openssl/lib/amd64/libssl.so.1.0.0: no version information available (required by openssl)
openssl: /opt/cprocsp/cp-openssl/lib/amd64/libssl.so.1.0.0: no version information available (required by openssl)
openssl: /opt/cprocsp/cp-openssl/lib/amd64/libssl.so.1.0.0: no version information available (required by openssl)
openssl: /opt/cprocsp/cp-openssl/lib/amd64/libcrypto.so.1.0.0: no version information available (required by openssl)
openssl: /opt/cprocsp/cp-openssl/lib/amd64/libcrypto.so.1.0.0: no version information available (required by openssl)
openssl: /opt/cprocsp/cp-openssl/lib/amd64/libcrypto.so.1.0.0: no version information available (required by openssl)
openssl: /opt/cprocsp/cp-openssl/lib/amd64/libcrypto.so.1.0.0: no version information available (required by openssl)
 * Reloading nginx configuration nginx
```

В качестве клиента я использовал [Chromium](https://github.com/deemru/chromium-gost) с поддержкой алгоритмов ГОСТ.
