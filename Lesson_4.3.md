# Lesson 4.3

### 1. Нужно найти и исправить все ошибки, которые допускает наш сервис
```json
{ "info" : "Sample JSON output from our service\t",
    "elements" :[
        { "name" : "first",
        "type" : "server",
        "ip" : 7175 
        },
        { "name" : "second",
        "type" : "proxy",
        "ip" : "71.78.22.43"
        }
    ]
}
```

### 2. Нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы.
```shell
import socket
import os
import json
import yaml

services = ['drive.google.com', 'mail.google.com', 'google.com']
addresses = {}
base_dir = os.path.dirname(os.path.abspath(__file__))


def write_to_file(data: str, path_to_file: str):
    with open(path_to_file, 'w') as f:
        f.write(data)


def prepare_data(data: dict):
    yaml_content = yaml.dump(data, indent=2, explicit_start=True, explicit_end=True)
    json_content = json.dumps(data, indent=2)
    write_to_file(yaml_content, f'{base_dir}/data.yaml')
    write_to_file(json_content, f'{base_dir}/data.json')


def check_services(targets: list, result: dict, should_be_written: bool):
    for target in targets:
        prev_ip = result.get(target)
        try:
            ip = socket.gethostbyname(target)

            if prev_ip:
                if ip != prev_ip:
                    should_be_written = True
                    print(f'[ERROR] {target} IP mismatch: {prev_ip} {ip}')
                else:
                    print(f'{target} - {ip}')
            else:
                print(f'{target} - {ip}')

            result[target] = ip
        except socket.gaierror:
            print(f'{target} - service is not available')

    if should_be_written:
        prepare_data(result)


check_services(services, addresses, True)

while True:
    print('')
    answer = input('To check again enter "yes" or enter "exit" to exit: ').lower()
    if answer == 'yes':
        check_services(services, addresses, False)
    elif answer == 'exit':
        break

```
