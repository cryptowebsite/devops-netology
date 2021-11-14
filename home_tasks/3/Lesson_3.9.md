# Lesson 3.9

### 1. Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей.
Выполнено.

### 2. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.
Выполнено.

### 3. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.

```shell
sudo apt install apache2
sudo a2enmod ssl
sudo systemctl restart apache2
sudo openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
-keyout /etc/ssl/private/apache-selfsigned.key \
-out /etc/ssl/certs/apache-selfsigned.crt \
-subj "/C=RU/ST=Moscow/L=Moscow/O=Company Name/OU=Org/CN=192.168.1.13"
sudo nano /etc/apache2/sites-available/192.168.1.13.conf
<VirtualHost *:443>   
    ServerName 192.168.1.13
    DocumentRoot /var/www/192.168.1.13  
    SSLEngine on   
    SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt   
    SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key
</VirtualHost>
<VirtualHost *:80>
    ServerName 192.168.1.13
    Redirect / https://192.168.1.13/
</VirtualHost>

sudo mkdir /var/www/192.168.1.13
sudo nano /var/www/192.168.1.13/index.html
<h1>My apache2 server</h1>

sudo a2ensite 192.168.1.13.conf
sudo apache2ctl configtest
sudo systemctl reload apache2
```

### 4. Проверьте на TLS уязвимости произвольный сайт в интернете.
```shell
./testssl.sh -U --sneaky https://www.minercrm.com/

###########################################################
    testssl.sh       3.1dev from https://testssl.sh/dev/
    (b8bff80 2021-09-24 14:21:04 -- )

      This program is free software. Distribution and
             modification under GPLv2 permitted.
      USAGE w/o ANY WARRANTY. USE IT AT YOUR OWN RISK!

       Please file bugs @ https://testssl.sh/bugs/

###########################################################

 Using "OpenSSL 1.0.2-chacha (1.0.2k-dev)" [~183 ciphers]
 on vagrant:./bin/openssl.Linux.x86_64
 (built: "Jan 18 17:12:17 2019", platform: "linux-x86_64")


 Start 2021-09-28 04:21:03        -->> 213.108.4.73:443 (www.minercrm.com) <<--

 rDNS (213.108.4.73):    powercolo-cloudservices.com.
 Service detected:       HTTP


 Testing vulnerabilities 

 Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
 CCS (CVE-2014-0224)                       not vulnerable (OK)
 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK), no session ticket extension
 ROBOT                                     Server does not support any cipher suites that use RSA key transport
 Secure Renegotiation (RFC 5746)           supported (OK)
 Secure Client-Initiated Renegotiation     not vulnerable (OK)
 CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
 BREACH (CVE-2013-3587)                    potentially NOT ok, "gzip deflate" HTTP compression detected. - only supplied "/" tested
                                           Can be ignored for static pages or if no secrets in the page
 POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
 TLS_FALLBACK_SCSV (RFC 7507)              No fallback possible (OK), no protocol below TLS 1.2 offered
 SWEET32 (CVE-2016-2183, CVE-2016-6329)    not vulnerable (OK)
 FREAK (CVE-2015-0204)                     not vulnerable (OK)
 DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                           make sure you don't use this certificate elsewhere with SSLv2 enabled services
                                           https://censys.io/ipv4?q=8FC922B944BFFE4257BFD359D9A6D297C34AF04C7E85746FD3A0533F37586CF9 could help you to find out
 LOGJAM (CVE-2015-4000), experimental      common prime with 2048 bits detected: RFC7919/ffdhe2048 (2048 bits),
                                           but no DH EXPORT ciphers
 BEAST (CVE-2011-3389)                     not vulnerable (OK), no SSL3 or TLS1
 LUCKY13 (CVE-2013-0169), experimental     not vulnerable (OK)
 Winshock (CVE-2014-6321), experimental    not vulnerable (OK)
 RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)
```

### 5. Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.
```shell
sudo apt install openssh-server
sudo systemctl start sshd.service
sudo systemctl enable sshd.service
ssh-keygen -t rsa -b 4096
ssh-copy-id <username>@<remote_host>
ssh <username>@<remote_host>
```

### 6. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.
```shell
mkdir -p ~/.ssh && chmod 700 ~/.ssh
touch ~/.ssh/config && chmod 600 ~/.ssh/config
nano ~/.ssh/config
Host my_server  
  HostName 192.168.1.13  
  IdentityFile ~/.ssh/id_rsa  
  User vagrant
Host *    
  User default_username    
  IdentityFile ~/.ssh/id_rsa    
  Protocol 2
```

### 7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.
```shell
sudo apt install tcpdump wireshark
sudo tcpdump -w 0001.pcap -i eth0 -c 100
```
[![imageup.ru](https://imageup.ru/img294/3808479/wireshark.png)](https://imageup.ru/img294/3808479/wireshark.png.html)

### 8. Просканируйте хост scanme.nmap.org. Какие сервисы запущены?
```shell
sudo apt install nmap
sudo nmap -O scanme.nmap.org

PORT      STATE SERVICE
22/tcp    open  ssh # SSH
80/tcp    open  http # HTTP
9929/tcp  open  nping-echo # утилита для обнаружения сети и аудита безопасности
31337/tcp open  Elite # средство для удаленного администрирования (часто троянская программа)
```

### 9. Установите и настройте фаервол ufw на web-сервер из задания 3. Откройте доступ снаружи только к портам 22,80,443
```shell
sudo apt install ufw
sudo ufw enable
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
```
