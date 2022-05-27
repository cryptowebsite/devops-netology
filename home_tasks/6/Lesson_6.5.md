# Lesson 6.5

### 1. Используя докер образ `centos:7` как базовый и документацию по установке и запуску `Elastcisearch`
```dockerfile
# Dockerfile

FROM centos:7
ARG user=elasticsearch
WORKDIR /usr/share
RUN useradd ${user} && \
    yum -y install wget perl-Digest-SHA && \
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.15.2-linux-x86_64.tar.gz && \
    wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.15.2-linux-x86_64.tar.gz.sha512 && \
    shasum -a 512 -c elasticsearch-7.15.2-linux-x86_64.tar.gz.sha512 && \
    tar -xzf elasticsearch-7.15.2-linux-x86_64.tar.gz && \
    rm elasticsearch-7.15.2-linux-x86_64.tar.gz elasticsearch-7.15.2-linux-x86_64.tar.gz.sha512 && \
    chown -R ${user}:${user} /usr/share/elasticsearch-7.15.2
USER ${user}
WORKDIR /usr/share/elasticsearch-7.15.2
ENV PATH=$PATH:/usr/share/elasticsearch-7.15.2/bin
COPY elasticsearch.yml config/
EXPOSE 9200
ENTRYPOINT ["elasticsearch"]
```

```yaml
# elasticsearch.yml

path.data: /var/lib
path.repo: ["/usr/share/elasticsearch-7.15.2/snapshot"]
node.name: "netology_test"
network.host: 0.0.0.0
discovery.type: single-node
```

```shell
# Создаём образ
docker build -t cryptodeveloper/elastcisearch:netology .

# Отправляем образ в репозиторий
docker push cryptodeveloper/elastcisearch:netology

# Сказать образ можно следующей командой
docker pull cryptodeveloper/elastcisearch:netology

# Увеличиваем количество областей виртуальной памяти
sudo sysctl -w vm.max_map_count=262144

# Запускаем контейнер
docker run -it -d --name ces -p 9200:9200 -v $PWD/data:/var/lib/ cryptodeveloper/elastcisearch:netology

# Выполняем запрос по пути
curl -X GET "localhost:9200/"

#{
#  "name" : "netology_test",
#  "cluster_name" : "elasticsearch",
#  "cluster_uuid" : "TeY0g_fxTJWdDLk1pVdszg",
#  "version" : {
#    "number" : "7.15.2",
#    "build_flavor" : "default",
#    "build_type" : "tar",
#    "build_hash" : "93d5a7f6192e8a1a12e154a2b81bf6fa7309da0c",
#    "build_date" : "2021-11-04T14:04:42.515624022Z",
#    "build_snapshot" : false,
#    "lucene_version" : "8.9.0",
#    "minimum_wire_compatibility_version" : "6.8.0",
#    "minimum_index_compatibility_version" : "6.0.0-beta1"
#  },
#  "tagline" : "You Know, for Search"
#}
```
Ссылка на репозиторий https://hub.docker.com/r/cryptodeveloper/elastcisearch

### 2. Добавьте в `elasticsearch` 3 индекса. Получите список индексов и их статусов. Получите состояние кластера `elasticsearch`. Как вы думаете, почему часть индексов и кластер находится в состоянии yellow? Удалите все индексы.
```shell
# Добавляем индексы
curl -H "Content-Type: application/json" -X PUT http://localhost:9200/ind-1 -d '
{
   "settings": {
    "index": {
      "number_of_shards": 1,  
      "number_of_replicas": 0 
    }
  }
}'

curl -H "Content-Type: application/json" -X PUT http://localhost:9200/ind-2 -d '
{
   "settings": {
    "index": {
      "number_of_shards": 2,  
      "number_of_replicas": 1 
    }
  }
}'

curl -H "Content-Type: application/json" -X PUT http://localhost:9200/ind-3 -d '
{
   "settings": {
    "index": {
      "number_of_shards": 4,  
      "number_of_replicas": 2 
    }
  }
}'

# Получаем список индексов и их статус
curl -X GET "localhost:9200/_cat/indices"

#green  open .geoip_databases tuZ1n2yGTmiER1-QIzlXmw 1 0 43 0 40.9mb 40.9mb
#green  open ind-1            kmFplo7-Q2aH6SGKhArLDg 1 0  0 0   208b   208b
#yellow open ind-3            UhxnVQpbQfeBubDxKa3yiw 4 2  0 0   832b   832b
#yellow open ind-2            Vgxq4zSXRfWrUHwRk2uGIw 2 1  0 0   416b   416b

# Получаем состояние кластера
curl -X GET "localhost:9200/_cat/health"

# 1638531904 11:45:04 elasticsearch yellow 1 1 8 8 0 0 10 0 - 44.4%

# Удаляем индексы
curl -X DELETE "localhost:9200/ind-1"
curl -X DELETE "localhost:9200/ind-2"
curl -X DELETE "localhost:9200/ind-3"
```
Часть индексов и кластер находится в состоянии `yellow` т.к. индексы имеют не достаточное количество реплик.

### 3. Создайте и восстановите `snapshot`
```shell
# Создаём директорию snapshots
docker exec -u elasticsearch ces sh -c "ls -l /usr/share/elasticsearch-7.15.2"

# Регистрируем директорию snapshots как snapshot repository
curl -H "Content-Type: application/json" -X PUT http://localhost:9200/_snapshot/netology_backup -d '
{   
   "type": "fs",
   "settings": {
    "location": "/usr/share/elasticsearch-7.15.2/snapshot"
  }
}'

# {"acknowledged":true}

# Создаём индекс test
curl -H "Content-Type: application/json" -X PUT http://localhost:9200/test -d '
{
   "settings": {
    "index": {
      "number_of_shards": 1,  
      "number_of_replicas": 0 
    }
  }
}'

# Получаем список индексов и их статус
curl -X GET "localhost:9200/_cat/indices"

# green open .geoip_databases 0Z8Ev2pqQnyy0VLgxamEZw 1 0 43 0 40.9mb 40.9mb
# green open test             snwkSL68SCyMV7Mp_xvEtg 1 0  0 0   208b   208b

# Создаем snapshot
curl -X PUT "localhost:9200/_snapshot/netology_backup/snapshot_1?wait_for_completion=true"

# Выводим список файлов директории snapshot
docker exec -u elasticsearch ces sh -c "ls -la /usr/share/elasticsearch-7.15.2/snapshot"

# total 56
# drwxr-xr-x 3 elasticsearch elasticsearch  4096 Dec  3 12:36 .
# drwxr-xr-x 1 elasticsearch elasticsearch  4096 Dec  3 12:06 ..
# -rw-r--r-- 1 elasticsearch elasticsearch   828 Dec  3 12:36 index-0
# -rw-r--r-- 1 elasticsearch elasticsearch     8 Dec  3 12:36 index.latest
# drwxr-xr-x 4 elasticsearch elasticsearch  4096 Dec  3 12:36 indices
# -rw-r--r-- 1 elasticsearch elasticsearch 27628 Dec  3 12:36 meta-vKJCfOSgRzOBVnMGjKVezw.dat
# -rw-r--r-- 1 elasticsearch elasticsearch   437 Dec  3 12:36 snap-vKJCfOSgRzOBVnMGjKVezw.dat

# Удаляем индекс test
curl -X DELETE "localhost:9200/test"

# Создаём индекс test2
curl -H "Content-Type: application/json" -X PUT http://localhost:9200/test2 -d '
{
   "settings": {
    "index": {
      "number_of_shards": 1,  
      "number_of_replicas": 0 
    }
  }
}'

# Получаем список индексов и их статус
curl -X GET "localhost:9200/_cat/indices"

# green open .geoip_databases 0Z8Ev2pqQnyy0VLgxamEZw 1 0 43 0 40.9mb 40.9mb
# green open test2            bt808Kj4RjSGZ64Jqk-sHQ 1 0  0 0   208b   208b

# Восстанавливаем snapshot
curl -H "Content-Type: application/json" -X POST localhost:9200/_snapshot/netology_backup/snapshot_1/_restore -d '
{
   "include_global_state": true
}'

# Получаем список индексов и их статус
curl -X GET "localhost:9200/_cat/indices"

# green open .geoip_databases WvCHqkD4QEChqb3weXikJQ 1 0 43 0 40.9mb 40.9mb
# green open test2            bt808Kj4RjSGZ64Jqk-sHQ 1 0  0 0   208b   208b
# green open test             0SRJviC-QE2iGeIADoegeg 1 0  0 0   208b   208b
```
