# Lesson 10.2

## 1. Опишите основные плюсы и минусы pull и push систем мониторинга.
Метод `push` означает отправку данных, инициируемую агентом, до сервера. При таком подходе мы можем более гибко настроить агент, а также отправлять данные на несколько серверов (при необходимости). Еще несомненным плюсом является возможность использования `UDP` протокола для передачи данных, т.к. он не проверяет целостность пакетов, ему не нужно ждать подтверждения от принимающей стороны, за счёт чего он гораздо быстрее своего брата `TCP` =). Но при таком подходе мы усложняем контроль за этими метриками на сервере мониторинга т.к. клиенты сами отправляют запросы на сервер, мы не можем контролировать их потом, а также в случае ошибки, кривой настройки и т.д. мы не сможем однозначно идентифицировать клиента. Еще к минусам можно добавить является наличие большого объёмы точек конфигурации (как правило, по количеству агентов мониторинга), что в свою очередь окажет сложность с управлением этими конфигурационными файлами. При использовании метода `PULL` сервер сам запрашивает данные от клиента, что позволяет полностью контролировать входящие данные, а также мы можем настроить защищённый `TLS proxy-server` для получения этих данных. При необходимости (невозможности зайти на сервер мониторинга) мы можем получить данные с агентов, отправив обычный `HTTP` запрос.

## 2. Какие из ниже перечисленных систем относятся к push модели, а какие к pull? А может есть гибридные?
* `Prometheus` - `pull`, но есть возможность отправлять данные, методом `push`, на приложение `pushgateway`, а затем забирать с него методом `pull`
* `TICK` - `push`
* `Zabbix` - `hybrid`
* `VictoriaMetrics` - `hybrid`
* `Nagios` - `push`

## 3. Запустите TICK-стэк
```shell
curl http://localhost:8086/ping

# Вывод пуст
```
```shell
curl http://localhost:8888

<!DOCTYPE html><html><head><meta http-equiv="Content-type" content="text/html; charset=utf-8"><title>Chronograf</title><link rel="icon shortcut" href="/favicon.fa749080.ico"><link rel="stylesheet" href="/src.9cea3e4e.css"></head><body> <div id="react-root" data-basepath=""></div> <script src="/src.a969287c.js"></script> </body></html>
```
```shell
curl http://localhost:9092/kapacitor/v1/ping

# Вывод пуст
```
```shell
docker ps

CONTAINER ID   IMAGE                                COMMAND                  CREATED          STATUS          PORTS                                                                                                                             NAMES
857e610f4b9a   chrono_config                        "/entrypoint.sh chro…"   53 seconds ago   Up 52 seconds   0.0.0.0:8888->8888/tcp, :::8888->8888/tcp                                                                                         sandbox_chronograf_1
8e3c919397c1   telegraf                             "/entrypoint.sh tele…"   54 seconds ago   Up 53 seconds   8092/udp, 8125/udp, 8094/tcp                                                                                                      sandbox_telegraf_1
c0993b80db90   kapacitor                            "/entrypoint.sh kapa…"   54 seconds ago   Up 53 seconds   0.0.0.0:9092->9092/tcp, :::9092->9092/tcp                                                                                         sandbox_kapacitor_1
76eddd063aed   sandbox_documentation                "/documentation/docu…"   54 seconds ago   Up 53 seconds   0.0.0.0:3010->3000/tcp, :::3010->3000/tcp                                                                                         sandbox_documentation_1
8c2aad7a5c12   influxdb                             "/entrypoint.sh infl…"   54 seconds ago   Up 53 seconds   0.0.0.0:8082->8082/tcp, :::8082->8082/tcp, 0.0.0.0:8086->8086/tcp, :::8086->8086/tcp, 0.0.0.0:8089->8089/udp, :::8089->8089/udp   sandbox_influxdb_1
```

[![http://localhost:8888](https://i.postimg.cc/NfTZ2DtF/TICK.png)](https://postimg.cc/HVY6fQV1)

P.S. Запускал согласно документации `./sandbox up`

## 4. Приведите скриншот с отображением метрик утилизации места на диске `disk->host->telegraf_container_id`
В БД `telegraf.autogen` в `measurments` отсутствуют вкладки `mem` и `disk`, зато есть `docker_container_mem->host->telegraf-getting-started` с полем `used_percent`. Среди всего оставшегося информацию о диске найти не получилось.

[![Проблема](https://i.postimg.cc/Bb4t10Qp/the-Problem.png)](https://postimg.cc/MM3zhgBf)

## 5. Добавьте в конфигурацию telegraf `deocker` плагин
[![docker](https://i.postimg.cc/PxbysY3q/Screenshot-from-2022-04-02-16-58-58.png)](https://postimg.cc/TLwgnLX8)

P.S. Плагин `deocker` был изначально добавлен в конфигурационный файл

## 6* Попробуйте создать свой dashboard
[![dashboard](https://i.postimg.cc/FK2kHrFq/dashboard.png)](https://postimg.cc/nsGhdtDY)

P.S. Метрика об использование диска в dashboard не была добавлена (пояснение в ответе на вопрос №4). В общем, мягко говоря ДЗ старенное т.к. на лекции мы проходили `prometheus`, а ДЗ выполняет по стеку`TICK`. ДЗ было сформированно 10 месяцев назад и при переезде с ветки `master` на `mnt-7` не понесло никаких изменений, исходя из сугубо моего анализа, за 10 месяцем поменялось немало и уже не соответствует данной инструкции.
