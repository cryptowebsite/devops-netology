# Lesson 3.4

### 1. Создайте самостоятельно простой unit-файл для node_exporter:
Создаем unit-файл и файл для настроек
```shell
sudo touch /etc/systemd/system/node-exporter.service
sudo touch /etc/default/node-exporter
```
unit-файл `node-exporter.service`
```shell
[Unit]
Description=Node Exporter

[Service]
EnvironmentFile=-/etc/default/node-exporter
ExecStart=/usr/sbin/node-exporter -f $EXTRA_OPTS
Restart=Always

[Install]
WantedBy=multi-user.target
```
Добавляем скрипт в автозагрузку, запускаем его и проверяем статус
```shell
sudo systemctl daemon-reload
sudo systemctl enable node-exporter.service
sudo systemctl start node-exporter.service
sudo systemctl status node-exporter.service
```
Получаем вывод последней команды, даже после перезагрузки
```shell
node-exporter.service - Node Exporter
  Loaded: loaded (/etc/systemd/system/node-exporter.service; enabled; vendor preset: enabled)
  Active: active (running) since Fri 2021-09-10 18:07:32 UTC; 3min 53s ago
Main PID: 629 (node-exporter)
  Tasks: 4 (limit: 4617)
  Memory: 13.6M
  CGroup: /system.slice/node-exporter.service
          └─629 /usr/sbin/node-exporter
```

### 2. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.
####  1. CPU
`node_cpu_seconds_total{cpu="<number_of_core>", mode="<mode_name>"}` - Количество секунд, затраченных на процессор в каждом режиме
<br>
Режимы:
- `user` - время выполнения обычных процессов, которые выполняются в режиме пользователя
- `nice` - время выполнения процессов с приоритетом nice, которые выполняются в режиме пользователя
- `system` - время выполнения процессов, которые выполняются в режиме ядра
- `idle` - время простоя CPU
- `iowait` - время ожидания I/O операций
- `irq` - время обработки аппаратных прерываний
- `softirq` - время обработки программных прерываний
- `steal` - время, которое используют другие операционные системы (при виртуализации)
- `guest` - время выполнения «гостевых» процессов (при виртуализации)
#### 2. memory
- `node_memory_MemTotal_bytes` - Общие количество памяти
- `node_memory_MemFree_bytes` - Количество свободной памяти
- `node_memory_MemAvailable_bytes` - Количество доступной памяти
#### 3. storage
- `node_disk_io_now` - Количество выполняемых операций ввода-вывода
- `node_disk_io_time_seconds_total` - Общее количество секунд, потраченных на выполнение операций ввода-вывода
- `node_disk_read_time_seconds_total` - Общее количество миллисекунд, потраченных на все операции чтения
- `node_disk_write_time_seconds_total` - Общее количество секунд, потраченных на все операции записи
- `node_filesystem_avail_bytes` - Пространство файловой системы, доступное пользователям без полномочий root
- `node_filesystem_free_bytes` - Свободное место в файловой системе в байтах
- `node_filesystem_readonly` - Размер файловой системы в байтах
#### 4. network
- `node_ipvs_incoming_bytes_total` - Общий объем входящих данных
- `node_ipvs_outgoing_bytes_total` - Общий объем исходящих данных
- `node_netstat_Icmp_InMsgs` - Входящие ICMP сообщения
- `node_netstat_Icmp_OutMsgs` - Исходящие ICMP сообщения

### 3. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.
Выполнено. Удобное средство для быстрого запуска мониторинга

### 4. Можно ли по выводу dmesg понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?
Да можем
```shell
dmesg | grep 'Hypervisor detected'
[    0.000000] Hypervisor detected: KVM
```

### 5. Как настроен sysctl fs.nr_open на системе по-умолчанию? Что означает этот параметр? Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?
`fs.nr_open` - максимальное количество дескрипторов файлов, которое может выделить процесс. Значение по умолчанию - 1024 * 1024 (1048576)
<br>
`ulimit -n` - максимальное количество открытых файловых дескрипторов

### 6. Покажите, что ваш процесс работает под PID 1 через `nsenter`
```shell
screen # Создаём первую сессию
# Нажимаем ctrl+a+c Для создания второй сессии
sudo -i unshare -f --pid --mount-proc /bin/sleep 1h # Запускаем долгий процесс в отдельном namespace
ps aux | grep sleep # Находим PID нашего процесса
sudo -i nsenter --target <PID> --pid --mount # Подключаемся к этому namespace
ps aux # Смотрим результат
# Получаем вывод
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.0   9828   596 pts/9    S+   09:29   0:00 /bin/sleep 1h
```

### 7. Найдите информацию о том, что такое `:(){ :|:& };:`. Какой механизм помог автоматической стабилизации? Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?
```shell
:(){ :|:& };: # Логическая бомба (fork bomb), создаёт функцию, которая запускает ещё два своих экземпляра , которые, в свою очередь снова запускают эту функцию (бесконечная рекурсия) и так до тех пор, пока этот процесс не займёт всю физическую память компьютера.
```
Функция ядра Linux `cgroup`, служит для управления ресурсами системы. По умолчанию `cgroup` распределяет ресурсы равномерно на три раздела:
- `System` - демоны и сервисы
- `User` - пользовательские сеансы
- `Machine` – виртуальные машины

Т.к. в нашем случае нет виртуальных машин ресурсы поделятся поровну между `System` и `User`. Далее (по умолчанию) ресурсы делятся внутри каждого раздела также равномерно.

Квоту на максимальное число процессов можно изменить следующим образом:
```shell
sudo systemctl set-property user-1000.slice TasksMax=<max_number_of_processes>
cat /sys/fs/cgroup/pids/user.slice/user-1000.slice/pids.max
```
