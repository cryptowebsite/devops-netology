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
