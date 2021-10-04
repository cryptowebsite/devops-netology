# Lesson 4.2

### 1. Какое значение будет присвоено переменной c? Как получить для переменной c значение 12? Как получить для переменной c значение 3?
```shell
#!/usr/bin/env python3

a = 1
b = '2'
c = a + b # Будет ошибка т.к. мы складываем строку и число. К сожалению python, в отличие например от JS, не умеет динамически конвертировать типы данных при арифметических операциях
c1 = int(str(1) + b) # 12
c2 = a + int(b) # 3
```

### 2. Как можно доработать скрипт, чтобы он исполнял требования вашего руководителя?
```shell
#!/usr/bin/env python3
import os

project_dir = '~/netology/sysadm-homeworks'
bash_command = [f'cd {project_dir}', 'git status']
result_os = os.popen(' && '.join(bash_command)).read()
is_first_print = True
full_path = os.popen(' && '.join([bash_command[0], 'pwd'])).read().strip()

for result in result_os.split('\n'):
    if result.find('Changes') != -1:
        if not is_first_print:
            print('')
        print(result.upper())
        is_first_print = False

    if result.find('modified') != -1:
        file = result.replace('\tmodified:   ', '')
        print(f'{full_path}/{file}')
```

### 3. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр.
```shell
#!/usr/bin/env python3
import os
from sys import argv

project_dir = argv[1] if len(argv) > 1 else '~/netology/sysadm-homeworks'

bash_command = [f'cd {project_dir}', 'git status']
result_os = os.popen(' && '.join(bash_command)).read()
is_first_print = True
full_path = os.popen(' && '.join([bash_command[0], 'pwd'])).read().strip()

for result in result_os.split('\n'):
    if result.find('Changes') != -1:
        if not is_first_print:
            print('')
        print(result.upper())
        is_first_print = False

    if result.find('modified') != -1:
        file = result.replace('\tmodified:   ', '')
        print(f'{full_path}/{file}')
```

### 4. Написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод.
```shell
#!/usr/bin/env python3
import socket

services = ['drive.google.com', 'mail.google.com', 'google.com']
addresses = {}


def check_services(targets: list, result: dict):
    for target in targets:
        prev_ip = result.get(target)
        try:
            ip = socket.gethostbyname(target)

            if prev_ip:
                if ip != prev_ip:
                    print(f'[ERROR] {target} IP mismatch: {prev_ip} {ip}')
                else:
                    print(f'{target} - {ip}')
            else:
                print(f'{target} - {ip}')

            result[target] = ip
        except socket.gaierror:
            print(f'{target} - service is not available')


check_services(services, addresses)

while True:
    print('')
    answer = input('To check again enter "yes" or to exit exit "exit": ')
    if answer == 'yes':
        check_services(services, addresses)
    elif answer == 'exit':
        break
```
