# Lesson 3.8

### 1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
```shell
telnet route-views.routeviews.org
show ip route <IP>

Routing entry for 1.53.4.0/24
  Known via "bgp 6447", distance 20, metric 0
  Tag 6939, type external
  Last update from 64.71.137.241 2w4d ago
  Routing Descriptor Blocks:
  * 64.71.137.241, from 64.71.137.241, 2w4d ago
      Route metric is 0, traffic share count is 1
      AS Hops 3
      Route tag 6939
      MPLS label: none

show bgp <IP>

BGP routing table entry for 1.53.4.0/24, version 1015108422
Paths: (7 available, best #5, table default)
  Not advertised to any peer
  Refresh Epoch 1
  3267 2603 4635 18403 18403 18403
    194.85.40.15 from 194.85.40.15 (185.141.126.1)
      Origin IGP, metric 0, localpref 100, valid, external
      path 7FE0A9B5C710 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3333 1103 2603 4635 18403 18403 18403
    193.0.0.56 from 193.0.0.56 (193.0.0.56)
      Origin IGP, localpref 100, valid, external
      Community: 0:4635 2603:302 2603:666 2603:64110 2603:64112 2603:64859 4635:4635 4635:65021 15169:12000 18403:20 18403:940 18403:1232 18403:4032 18403:13515
      path 7FE17274B148 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 2
  3303 6939 18403 18403
    217.192.89.50 from 217.192.89.50 (138.187.128.158)
      Origin IGP, localpref 100, valid, external
      Community: 3303:1006 3303:1021 3303:1030 3303:3067 6939:7049 6939:8702 6939:9003
      path 7FE144006678 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  20130 6939 18403 18403
    140.192.8.16 from 140.192.8.16 (140.192.8.16)
      Origin IGP, localpref 100, valid, external
      path 7FE0DA4BFE10 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  6939 18403 18403
    64.71.137.241 from 64.71.137.241 (216.218.252.164)
      Origin IGP, localpref 100, valid, external, best
      path 7FE031BD4E60 RPKI State valid
      rx pathid: 0, tx pathid: 0x0
  Refresh Epoch 1
  7660 4635 18403 18403 18403
    203.181.248.168 from 203.181.248.168 (203.181.248.168)
      Origin IGP, localpref 100, valid, external
      Community: 0:4635 4635:4635 4635:65021 7660:6 7660:9001 15169:12000 18403:20 18403:940 18403:1232 18403:4032 18403:13515
      path 7FE115102058 RPKI State valid
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  1351 6939 18403 18403
    132.198.255.253 from 132.198.255.253 (132.198.255.253)
      Origin IGP, localpref 100, valid, external
      path 7FE0D4D8E990 RPKI State valid
      rx pathid: 0, tx pathid: 0
```

### 2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.
```shell
sudo ip link add dummy0 type dummy
sudo ip link set dev dummy0 up
sudo ip route add 192.168.88.0/24 dev dummy0
sudo ip route add 10.10.0.0/16 dev dummy0
sudo ip route add 172.16.0.0/16 dev dummy0
ip route

default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100 
10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 
10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100 
10.10.0.0/16 dev dummy0 scope link 
172.16.0.0/16 dev dummy0 scope link 
192.168.88.0/24 dev dummy0 proto kernel scope link src 192.168.88.0 
```

### 3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.
```shell
netstat -tulpn

Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address  Foreign Address State   PID/Program name    
tcp        0      0 0.0.0.0:111    0.0.0.0:*       LISTEN  1/init               # RPC удаленный вызов процедур
tcp        0      0 127.0.0.53:53  0.0.0.0:*       LISTEN  576/systemd-resolve  # DNS
tcp        0      0 0.0.0.0:22     0.0.0.0:*       LISTEN  3703/sshd: /usr/sbi  # SSH
tcp6       0      0 :::111         :::*            LISTEN  1/init               # RPC удаленный вызов процедур
tcp6       0      0 :::22          :::*            LISTEN  3703/sshd: /usr/sbi  # SSH
udp        0      0 127.0.0.53:53  0.0.0.0:*               576/systemd-resolve  # DNS
udp        0      0 10.0.2.15:68   0.0.0.0:*               424/systemd-network  # BOOTP, а также DHCP
udp        0      0 0.0.0.0:111    0.0.0.0:*               1/init               # RPC удаленный вызов процедур
udp6       0      0 :::111         :::*                    1/init               # RPC удаленный вызов процедур
```

### 4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?
```shell
ss -u -a

State   Recv-Q  Send-Q   Local Address:Port    Peer Address:Port  Process                                     
UNCONN  0       0        127.0.0.53%lo:domain       0.0.0.0:*             # DNS                                                                      
UNCONN  0       0       10.0.2.15%eth0:bootpc       0.0.0.0:*             # DHCP                                                                      
UNCONN  0       0              0.0.0.0:sunrpc       0.0.0.0:*             # RPC                                                                       
UNCONN  0       0                 [::]:sunrpc          [::]:*             # RPC                                                                       
```

### 5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали.
[![Схема сети](https://imageup.ru/img3/3806784/network.png)](https://imageup.ru/img3/3806784/network.png.html)