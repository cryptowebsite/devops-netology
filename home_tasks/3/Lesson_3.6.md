# Lesson 3.6

### 1. Укажите полученный HTTP код, что он означает?
`301` (Moved Permanently) - Этот код ответа значит, что URI запрашиваемого ресурса был изменён.

### 2. Укажите полученный HTTP код. Какой запрос обрабатывался дольше всего?
Т.к. мы обращались по 80 порту (http), то соответственно произошел редирект на 443 порт (https), в чём мы можем убедиться получив статус `307` (Internal Redirect). Дольше го всего обрабатывался запрос на получения HTML документа.

[![Скриншот](https://imageup.ru/img225/3801695/stackoverflow.png)](https://imageup.ru/img225/3801695/stackoverflow.png.html)

### 3. Какой IP адрес у вас в интернете?
```shell
wget -qO- eth0.me
```

### 4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS?
```shell
whois <my_ip> | egrep -w 'address:|descr:' # Провайдер
whois <my_ip> | grep origin # AS
```

### 5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS?
```shell
traceroute -An 8.8.8.8
 1  10.0.2.2 [*]  0.318 ms  0.217 ms  0.154 ms # VirtualBox network
 2  192.168.1.1 [*]  0.966 ms  1.089 ms  1.021 ms # My local network
 3  100.123.1.177 [*]  41.751 ms  41.589 ms  42.650 ms # FPT Telecom
 4  42.112.0.125 [AS18403]  14.117 ms 42.112.0.127 [AS18403]  18.390 ms 42.112.0.125 [AS18403]  14.740 ms # FPT Telecom
 5  100.123.0.20 [*]  16.100 ms  15.986 ms  16.609 ms # FPT Telecom
 6  118.69.132.157 [AS18403]  9.298 ms  7.809 ms  8.566 ms # FPT Telecom
 7  42.117.11.158 [AS18403]  40.945 ms  40.865 ms  41.574 ms # FPT Telecom
 8  42.117.11.157 [AS18403]  9.724 ms *  8.190 ms # FPT Telecom
 9  118.69.165.33 [AS18403]  41.255 ms  41.166 ms  41.106 ms # FPT Telecom
10  118.70.2.169 [AS18403]  32.473 ms 209.85.148.242 [AS15169]  55.873 ms 118.70.2.169 [AS18403]  32.445 ms # FPT Telecom
11  209.85.148.240 [AS15169]  35.374 ms  35.539 ms * # Google LLC
12  * 8.8.8.8 [AS15169]  47.157 ms 66.249.94.223 [AS15169]  49.341 ms # Google LLC
```
Пакет прошёл через 2 AS, принадлежащие "FPT Telecom" (AS18403) и "Google LLC" (AS15169)

### 6. На каком участке наибольшая задержка - delay?
```shell
mtr -zn 8.8.8.8
                                Packets               Pings
 Host                         Loss%   Snt   Last   Avg  Best  Wrst StDev
 1. AS???    10.0.2.2          0.0%   242    0.2   0.4   0.1   0.8   0.2
 2. AS???    192.168.1.1       0.0%   242    1.1   1.2   0.5   7.2   1.1
 3. AS???    100.123.1.177     0.0%   242    2.6   4.5   1.1  93.6  11.0
 4. AS18403  42.112.0.127      0.0%   242   22.4  18.5  16.4  37.4   3.0
 5. AS???    100.123.0.20      0.0%   242   16.6  18.0  16.4  40.4   2.1
 6. AS18403  118.69.132.157    6.2%   242    9.5  10.2   7.6  43.8   4.4
 7. AS18403  42.117.11.158     1.2%   242   41.3  42.7  40.4  81.4   5.8
 8. AS18403  42.117.11.157     5.0%   242    8.6   9.7   7.8  30.5   2.7
 9. AS18403  118.69.165.33     0.0%   241   43.6  42.7  41.5  48.3   1.0
10. AS15169  209.85.148.242    0.0%   241   50.2  49.5  48.5  55.9   0.8
11. AS15169  72.14.233.125     0.0%   241   42.9  43.2  41.9  49.1   1.3
12. AS15169  66.249.95.129     0.0%   241   42.2  41.9  40.9  45.8   0.7
13. AS15169  8.8.8.8           0.0%   241   47.7  47.3  46.4  53.2   0.6
```
Наибольшая задержка происходит на ip-адресе 209.85.148.242 автономной системы (AS15169), принадлежащей компании "Google LLC"

### 7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи?
```shell
dig dns.google

...
dns.google.             355     IN      A       8.8.4.4
dns.google.             355     IN      A       8.8.8.8
...
```

### 8. Какое доменное имя привязано к IP?
```shell
dig -x 8.8.8.8

...
8.8.8.8.in-addr.arpa.   73459   IN      PTR     dns.google.
...
```
```shell
dig -x 8.8.4.4

...
4.4.8.8.in-addr.arpa.   85127   IN      PTR     dns.google.
...
```
