# Lesson 10.1

## 1. Какой минимальный набор метрик вы выведите к проекту (`http`, `io disk`, `вычесления`) в мониторинг и почему?
* количество свободного дискового пространства
* количество оставшихся inode
* скорость обращения к диску (как на чтение так и на запись)
* назрузка сетевого интерефейса (как входящего так и исходящего трафика)
* нагрузка CPU
* количество свободной RAM

## 2. Провести объяснительный разговор с менеджером проекта.
Объяснить назначение основных метрик менеджеру, а также влияние этих метрик на `SLI`

## 3. Предложить решение бюбжетной системы мониторинга, для получения ошибок приложения.
Выйти из ситуации можно разными спсобами, например воспользоваться бесплатным планом облачных сервисов типа `Datadog` или `New Relic`. Или, что на мой взгляд булее лучший вариант использовать стек `ELK` или другой ему подобный. И конечно же мы не ограничены в разработке своего приложения, которрое сможет как-то собирать метрики, парситиь их для предствления в красиво-чиатемом виде, выводить отчеты на экран или отправлять их в уведомлениях.



## 4. Найти ошибку в расчёте `SLI`: `summ_2xx_requests/summ_all_requests`
В данной формуле не учтены 3xx коды ответов (перенаправление). Правильная формула `SLI = (summ_2xx_requests + summ_3xx_requests)/(summ_all_requests)`

## 5. Написать скрипт для собора метрик из каталога `/proc`
`monitoring.py`
```python
import datetime
from typing import Dict


class Monitoring:
    def __init__(self, logdir: str):
        self.logdir = logdir

    def __get_info(self, file: str) -> str:
        with open(file, 'r') as f:
            data = f.read()
            return data

    def __write_to_file(self, file: str, data: str):
        with open(file, 'a') as f:
            f.write(data + '\n')
            return self

    def __strip_str(self, string: str, start_str: str, end_str: str) -> str:
        string = string[len(start_str):]
        index_right = string.find(end_str)
        return string[:index_right].strip()

    def __metric_available_ram(self) -> Dict[str, str]:
        data = self.__get_info('/proc/meminfo')
        data = self.__strip_str(data, 'MemAvailable:', 'kB')
        return {"ram_available": f"{data} kB"}

    def __metric_io_disk(self) -> Dict[str, str]:
        data = self.__get_info('/proc/diskstats')
        disk = 'nvme0n1'
        data = self.__strip_str(data, disk, '\n')
        return {f"stats_disk:{disk}": data}

    def __metric_sys_load(self) -> Dict[str, str]:
        data = self.__get_info('/proc/loadavg')
        return {f"sys_loadavg": data.strip()}

    def __metric_stat_cpu(self) -> Dict[str, str]:
        data = self.__get_info('/proc/stat')
        data = self.__strip_str(data, 'cpu', '\n')
        return {f"stat_cpu": data}

    def write_metric(self):
        methods = [
            self.__metric_available_ram,
            self.__metric_io_disk,
            self.__metric_sys_load,
            self.__metric_stat_cpu
        ]

        now = datetime.datetime.now()
        filetime = now.strftime('%y-%m-%d')
        filename = f'{self.logdir}/{filetime}-awesome-monitoring.log'
        logs = {"timestamp": now.timestamp()}

        for method in methods:
            logs.update(method())

        self.__write_to_file(filename, str(logs))
        return self


metrics = Monitoring('/var/log')
metrics.write_metric()
```

`YY-MM-DD-awesome-monitoring.log`
```text
{'timestamp': 1648471801.650183, 'ram_available': '11676896 kB', 'stats_disk:nvme0n1': '238549697 36732282 2509724269 26153168 416307666 34597449 15633999730 116099415 0 61942492 143347958 210848 0 3316100584 95215 3143048 1000158', 'sys_loadavg': '2.03 2.37 2.48 4/2156 403643\n', 'stat_cpu': '29217056 326363 56102659 733487094 1614152 0 138806 0 0 0'}
{'timestamp': 1648471861.669192, 'ram_available': '12705200 kB', 'stats_disk:nvme0n1': '238575014 36739915 2510013965 26156116 416437460 34604237 15638004762 116137328 0 61958388 143389033 210848 0 3316100584 95215 3143619 1000373', 'sys_loadavg': '2.05 2.32 2.45 3/1976 403803\n', 'stat_cpu': '29217838 326425 56113914 733570752 1614200 0 138811 0 0 0'}
{'timestamp': 1648471921.687588, 'ram_available': '12728856 kB', 'stats_disk:nvme0n1': '238596779 36740326 2510192237 26158832 416574902 34607979 15642699554 116180577 0 61973648 143435176 210848 0 3316100584 95215 3144228 1000551', 'sys_loadavg': '2.10 2.29 2.43 3/1954 403865\n', 'stat_cpu': '29218955 326491 56124924 733654428 1614242 0 138837 0 0 0'}
{'timestamp': 1648471981.705766, 'ram_available': '12764920 kB', 'stats_disk:nvme0n1': '238615592 36740553 2510344749 26160755 416675009 34611849 15645032090 116203561 0 61987580 143460258 210848 0 3316100584 95215 3144786 1000725', 'sys_loadavg': '2.17 2.27 2.42 3/1958 403941\n', 'stat_cpu': '29219831 326546 56135864 733738353 1614277 0 138840 0 0 0'}
{'timestamp': 1648472041.723891, 'ram_available': '12781228 kB', 'stats_disk:nvme0n1': '238636444 36741916 2510522469 26163241 416792923 34614877 15648733682 116236936 0 62001728 143496360 210848 0 3316100584 95215 3145373 1000966', 'sys_loadavg': '2.35 2.33 2.43 3/1941 403991\n', 'stat_cpu': '29220280 326613 56146901 733822682 1614324 0 138853 0 0 0'}
```

`crontab -e`
```text
*/1  * * * * python3 <PATH_TO_THE_SCRIPT>/monitoring.py
```
