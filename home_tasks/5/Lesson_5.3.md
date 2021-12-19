# Lesson 5.3

### 1. Создайте свой fork образа, реализуйте функциональность: запуск веб-сервера в фоне с индекс-страницей.
https://hub.docker.com/repository/docker/cryptodeveloper/nginx

```shell
docker pull cryptodeveloper/nginx:netology
docker run -d -p 80:80 cryptodeveloper/nginx:netology
```

### 2. Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?
#### 2.1 Высоконагруженное монолитное java веб-приложение
По скольку приложение одно, его можно не изолировать и развернуть на `физическом сервере`. В другом случае мы можем заранее подумать о будущих возможных миграциях и запустить это в `ВМ` или `docker-контейнере`.

#### 2.2 Nodejs веб-приложение
Так же подойдут все три варианта, но лучшим на мой взгляд будет `docker` т.к. он облегчит переезд, в случае необходимости, на другой сервер и позволит запустить рядом ещё изолированные приложения, например `postgres`, `react` и т.д. отлично сочетаются с `node js` =).

#### 2.3 Мобильное приложение c версиями для Android и iOS
Отлично подойдет `docker`, т.к. мы можем присваивать тег с версией приложения каждому образу. 

#### 2.4 Шина данных на базе Apache Kafka
Опять же `docker` т.к. сможем легко мигрировать вместе с нашими микросервисами.

#### 2.5 Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana
`docker` для быстрого и удобного развертывания кластеров

#### 2.6 Мониторинг-стек на базе Prometheus и Grafana
Тут все зависит от того что мы хотим мониторить. Если это приложение на физическом сервере, то можно развернуть это дело на всех трёх вариантах, но чаще всего приложения живут в облаке и тогда разумным решением будет `docker`.

#### 2.7 MongoDB, как основное хранилище данных для java-приложения
Всё как в прошлом случае, можно использовать все три варианта, но скорее всего наше приложение живёт в облаке, то соответственно разумно будет снова использовать `docker`, т.к. он позволит легко мигрировать на другой сервер.

#### 2.8 Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry
Можно использовать много вариантов, но я бы подумал о безопасности, развернул на физическом сервере (в случае отсутствия отдельного свободного сервера, возпользовался бы возможностями аппаратной виртуализации) `docker-контейнер` для хранения наших исходников.


### 3. Работа с контейнером
#### 3.1 Запустите первый контейнер из образа centos c любым тэгом в фоновом режиме, подключив папку `/data` из текущей рабочей директории на хостовой машине в `/data` контейнера. 
```shell
docker run -d -it -v ~/Development/Study/devops/devops-netology/docker/data:/data --name centos_srv centos
```
#### 3.2 Запустите второй контейнер из образа debian в фоновом режиме, подключив папку `/data` из текущей рабочей директории на хостовой машине в `/data` контейнера
```shell
docker run -d -t -v ~/Development/Study/devops/devops-netology/docker/data:/data --name debian_srv debian
```
#### 3.3 Подключитесь к первому контейнеру с помощью docker exec и создайте текстовый файл любого содержания в `/data`
```shell
docker exec centos_srv touch /data/the_file_create_by_centos_srv
```
#### 3.4 Добавьте еще один файл в папку `/data` на хостовой машине
```shell
touch ./data/the_file_created_by_the_host
```
#### 3.5 Подключитесь во второй контейнер и отобразите листинг и содержание файлов в `/data` контейнера.
```shell
docker exec centos_srv ls -l /data

total 0
-rw-r--r-- 1 root root 0 Nov  5 10:23 the_file_create_by_centos_srv
-rw-rw-r-- 1 1000 1000 0 Nov  5 10:23 the_file_created_by_the_host
```

### 4. Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.
https://hub.docker.com/repository/docker/cryptodeveloper/ansible

```shell
docker pull cryptodeveloper/node01:netology
```

P.S. В 4-ом задание в `Dockerfile` в 11-ой строке был поставлен лишний символ - "2" в конце строки. Пришлось удалить для успешной сборки.