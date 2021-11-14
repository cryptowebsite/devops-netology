# Lesson 3.5

### 1. Узнайте о sparse (разряженных) файлах.
Выполнено

### 2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
Нет не могут. В отличие от символических ссылок, жёсткие ссылки имеют тот же `i-node` что и файл. И соответственно мы не может повесить разные права на одну `i-node`.

### 3. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile
```shell
vagrant destroy
nano Vagrantfile_RAID
```

### 4. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.
```shell
sudo fdisk /dev/sdb
g # создадим GPT таблицу разделов
n # создаем раздел
+2G # Последний сектор указываем таким образом ))
n # создаем следующий раздел
# Принимаем настройки секторов по умолчанию для использования всего оставшегося места на диске
w # Записываем изменения на диск
```

### 5. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.
```shell
sudo sfdisk -d /dev/sdb > disk_config # сохраняем конфиг
sudo sfdisk /dev/sdc < disk_config #  разворачиваем конфиг на новый диск
```

### 6. Соберите `mdadm` RAID1 на паре разделов 2 Гб.
```shell
sudo mdadm --create /dev/md1 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
```

### 7. Соберите `mdadm` RAID0 на второй паре маленьких разделов.
```shell
sudo mdadm --create /dev/md0 --level=0 --raid-devices=2 /dev/sdb2 /dev/sdc2
```

### 8. Создайте 2 независимых PV на получившихся md-устройствах.
```shell
sudo pvcreate /dev/md0 /dev/md1
```

### 9. Создайте общую volume-group на этих двух PV.
```shell
sudo vgcreate volume_group /dev/md0 /dev/md1
```

### 10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
```shell
sudo lvcreate -L 100M -n lv_volume volume_group /dev/md0
```

### 11. Создайте `mkfs.ext4` ФС на получившемся LV.
```shell
sudo mkfs.ext4 /dev/volume_group/lv_volume
```

### 12. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.
```shell
mkdir /tmp/new
sudo mount -t ext4 /dev/volume_group/lv_volume /tmp/new
```

### 13. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.
```shell
sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
```

### 14. Прикрепите вывод `lsblk`.
```shell
lsblk

NAME                         MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                            8:0    0   64G  0 disk  
├─sda1                         8:1    0  512M  0 part  /boot/efi
├─sda2                         8:2    0    1K  0 part  
└─sda5                         8:5    0 63.5G  0 part  
  ├─vgvagrant-root           253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1         253:1    0  980M  0 lvm   [SWAP]
sdb                            8:16   0  2.5G  0 disk  
├─sdb1                         8:17   0    2G  0 part  
│ └─md1                      9:127  0    2G  0 raid1 
└─sdb2                         8:18   0  511M  0 part  
  └─md0                      9:126  0 1017M  0 raid0 
    └─volume_group-lv_volume 253:2    0  100M  0 lvm   /tmp/new
sdc                            8:32   0  2.5G  0 disk  
├─sdc1                         8:33   0    2G  0 part  
│ └─md1                      9:127  0    2G  0 raid1 
└─sdc2                         8:34   0  511M  0 part  
  └─md0                      9:126  0 1017M  0 raid0 
    └─volume_group-lv_volume 253:2    0  100M  0 lvm   /tmp/new
```

### 15. Протестируйте целостность файла:
```shell
gzip -t /tmp/new/test.gz
echo $?

0
```

### 16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
```shell
sudo pvmove /dev/md0 /dev/md1
```

### 17. Сделайте `--fail` на устройство в вашем RAID1 md.
```shell
sudo mdadm /dev/md1 -f /dev/sdc1
```

### 18. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.
```shell
dmesg

[ 1389.899194] md/raid1:md1: Disk failure on sdc1, disabling device.
               md/raid1:md1: Operation continuing on 1 devices.

```

### 19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:
```shell
gzip -t /tmp/new/test.gz
echo $?

0
```

### 20. Погасите тестовый хост,` vagrant destroy`.
```shell
exit
vagrant destroy
```
