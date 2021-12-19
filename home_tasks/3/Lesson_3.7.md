# Lesson 3.7

### 1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?
- `Linux`
```shell
ip link
```
- `Windows`
```shell
ipconfig /all
```

### 2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?
Протокол называется `LLDP`, пакет называется `lldpd`.

### 3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.
Технология используемая для разделения L2 коммутатора на несколько виртуальных сетей называется `VLAN`. В Linux пакет называется `vlan`. Настроить `VLAN` можно с помощью следующих команд: 
```shell
# Добавление VLAN-интерфейса
sudo ip link add link <devb_name> name <vlan_name> type vlan id <vlan-id> reorder_hdr on|off loose_binding on|off gvrp on|off ingress-qos-map <from>:<to> egress-qos-map <from>:<to>
# Изменение интерфейса
sudo ip link set dev <vlan_name> type vlan <option> <value>
# удаление интерфейса
sudo ip link del <vlan_name>
```

```shell
#  пример конфига
nano /etc/network/interfaces

auto vlan888
iface vlan888 inet static
        address 192.168.1.1
        netmask 255.255.255.0
        vlan_raw_device eth0
auto eth0.888
iface eth0.888 inet static
        address 192.168.1.1
        netmask 255.255.255.0
        vlan_raw_device eth0
```

### 4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.
Существует `динамическая` и `статическая` агрегация интерфейсов в Linux. 

#### Типы балансировки нагрузки в Linux
- `Mode-0(balance-rr)` - режим по умолчанию. Обеспечивается балансировку нагрузки и отказоустойчивость.
- `Mode-1(active00-backup)` - один интерфейс работает в активном режиме, остальные в ожидающем.
- `Mode-2(balance-xor)` - передача пакетов распределяется по типу входящего и исходящего трафика, режим дает балансировку нагрузки и отказоустойчивость.
- `Mode-3(broadcast)` - происходит передача во все объединенные интерфейсы, тем самым обеспечивая отказоустойчивость.
- `Mode-4(802.3ad)` - динамическое объединение одинаковых портов. В данном режиме можно значительно увеличить пропускную способность входящего так и исходящего трафика.
- `Mode-5(balance-tlb)` - адаптивная балансировки нагрузки трафика.
- `Mode-6(balance-alb)` - работает по антологии с прошлым режимом, но имеет более совершенный алгоритм балансировки нагрузки.
#### Опции для балансировки
- `arp_interval` - Частота мониторинга канала ARP.
- `arp_ip_target` - Указывает IP-адреса, которые будут использоваться в качестве одноранговых узлов мониторинга ARP, когда `arp_interval` > 0
- `downdelay` - Задает время ожидания в миллисекундах перед отключением ведомого устройства после обнаружения сбоя связи.
- `lacp_rate` - Опция, указывающая скорость, с которой мы будем просить нашего партнера по каналу передавать пакеты LACPDU в режиме 802.3ad.
- `miimon` - Частота мониторинга канала MII.

```shell
#  пример конфига
sudo nano /etc/network/interfaces

auto bond0
iface bond0 inet static
	address 192.168.1.150
	netmask 255.255.255.0	
	gateway 192.168.1.1
	dns-nameservers 192.168.1.1 8.8.8.8
	dns-search domain.local
		slaves eth0 eth1
		bond_mode 0
		bond-miimon 100
		bond_downdelay 200
		bond_updelay 200
```

### 5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.
В сети с маской `/29` присутствует 8 адресов, но для хостов доступно только 6 т.к. первый адрес определяет сеть, а последний используется для широковещательного запроса.
Из сети с маской `/24` можно получить 32 сети с маской `/29`, вот несколько примеров:
- `10.10.10.0/29`
- `10.10.10.8/29`
- `10.10.10.16/29`

### 6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.
- `100.64.0.0/26`
- `100.64.0.64/26`

### 7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?
- `Linux`
```shell
arp -a # Показать ARP таблицу
sudo ip neigh flush all # Очистить ARP кеш
sudo arp -d <IP> # Удалить запись с определённым ip
```
- `Windows`
```shell
arp -a # Показать ARP таблицу
arp -d # Очистить ARP кеш
arp -d <IP> # Удалить запись с определённым ip
```