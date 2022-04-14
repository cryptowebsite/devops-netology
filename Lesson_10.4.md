# Lesson 10.4

## 1. Поднять `elasticsearch`, `logstash`, `kibana`, и `filebeat`

### 1.1 Подготовка
```shell
# увеличиваем максимальный объём виртуальной памяти
sudo sysctl -w vm.max_map_count=262144
# меняем права на filebeat.yml
sudo chmod go-w configs/filebeat.yml
sudo chown 0:0 configs/filebeat.yml
```

Создаём `kibana.yml`
```yaml
server.name: kibana
server.host: "0"
elasticsearch.hosts: ["http://es-hot:9200"]
```

Следующие шаги можно пропустить, если ипользовать файлы конфигурации и `docker-compose.yml` из новой ветки `elk-hw`.

А также добавляем в `docker-compose.yml` в сервис `logstash` сеть `elastic` и в сервис `kibana` волум с ранее созданным конфигом (`- ./configs/kibana.yml:/usr/share/kibana/config/kibana.yml:ro`). Еще необходимо исправить подключения двух конфигурационных файлов в сервис `logstash` - `- ./configs/logstash.conf:/usr/share/logstash/pipeline/logstash.conf:ro` и `- ./configs/logstash.yml:/usr/share/logstash/config/logstash.yml:ro`.

[![docker.png](https://i.postimg.cc/gJtJjqJV/docker.png)](https://postimg.cc/WFrjfZ0z)

[![kibanba.png](https://i.postimg.cc/3J2kgKcj/kibanba.png)](https://postimg.cc/QHxNDrsV)


## 2. Создайте несколько `index-patterns`

[![index.png](https://i.postimg.cc/sgBRJHfH/index.png)](https://postimg.cc/v4djYzV5)

[![search.png](https://i.postimg.cc/qqTpgs8B/search.png)](https://postimg.cc/S2DBvzTH)

P.S. Даже после устранения всех ошибок, передать логи через `logstash` не получилось, только напрямую `filebeat->elasticsearch`. 