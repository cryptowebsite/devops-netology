# Lesson 6.2

### 1. Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.
Настраиваем переменное окружение и запускаем контейнер. Не хранить же пароль в манифесте =)
```shell
 . ./setenv.sh && docker-compose up -d
```
```yaml
# docker-compose.yml

version: '3.9'
services:
   postgres:
     container_name: ${CONTAINER_NAME}
     image: postgres:12
     volumes:
       - /home/irobot/Development/Study/devops/devops-netology/lesson_6.2/data:/var/lib/postgresql/data
       - /home/irobot/Development/Study/devops/devops-netology/lesson_6.2/backup:/var/lib/postgresql/backup
       - /home/irobot/Development/Study/devops/devops-netology/lesson_6.2/scheme:/var/lib/postgresql/scheme
     environment:
       POSTGRES_PASSWORD: ${POSTGRES_USER_PASSWORD}
       POSTGRES_DB: "postgres"
       POSTGRES_USER: "postgres"
       PGDATA: "/var/lib/postgresql/data"
     restart: always
     ports:
      - "5432:5432"
```
P.S. Здесь можно сразу указать имена нашей будущей БД и пользователя, но это задача номер №2, поэтому решил оставить все почти в дефолтном виде. Еще создал дополнительный волум для SQL-сценариев.

### 2. Создать пользователя и БД.
```shell
# Создаем пользователя
docker exec -u postgres $CONTAINER_NAME psql -c "CREATE ROLE \"$TEST_ADMIN_USER\" WITH LOGIN ENCRYPTED PASSWORD '$TEST_ADMIN_USER_PASSWORD';"
# Создаем БД
docker exec -u postgres $CONTAINER_NAME createdb $DB_NAME
# Создаём таблицы orders и clients
docker exec -u postgres $CONTAINER_NAME psql -d $DB_NAME -a -f "/var/lib/postgresql/scheme/create.sql"
```

```postgresql
-- create.sql

CREATE TABLE IF NOT EXISTS orders
(
    id SERIAL PRIMARY KEY,
    name CHARACTER VARYING(50),
    price INTEGER
);

CREATE TABLE IF NOT EXISTS clients
(
    id SERIAL PRIMARY KEY,
    last_name CHARACTER VARYING(50),
    country CHARACTER VARYING(50),
    orderId INTEGER REFERENCES orders (id)
);

CREATE INDEX IF NOT EXISTS idx_clients_country ON clients (country);
```

```shell
# Даём права пользователю test-admin-user
docker exec -u postgres $CONTAINER_NAME psql -d $DB_NAME -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO \"$TEST_ADMIN_USER\";"
# Создаем пользователя test-simple-user
docker exec -u postgres $CONTAINER_NAME psql -c "CREATE ROLE \"$TEST_SIMPLE_USER\" WITH LOGIN ENCRYPTED PASSWORD '$TEST_SIMPLE_USER_PASSWORD';"
# Даём права пользователю test-simple-user на SELECT/INSERT/UPDATE/DELETE
docker exec -u postgres $CONTAINER_NAME psql -d $DB_NAME -c "GRANT SELECT, INSERT, UPDATE, DELETE ON orders, clients TO \"$TEST_SIMPLE_USER\";"
```

#### РЕЗУЛЬТАТ
##### 1. итоговый список БД

```shell
docker exec -u postgres $CONTAINER_NAME psql -c "\l"
```
[![1.png](https://i.postimg.cc/RhCHHB10/1.png)](https://postimg.cc/mzqDvK5x)

##### 2. описание таблиц (describe)
##### orders
```shell
docker exec -u postgres $CONTAINER_NAME psql -d $DB_NAME -c "\d+ orders"
```
[![2.png](https://i.postimg.cc/rFmh6X6c/2.png)](https://postimg.cc/qgPcnFMZ)

##### clients
```shell
docker exec -u postgres $CONTAINER_NAME psql -d $DB_NAME -c "\d+ clients"
```
[![3.png](https://i.postimg.cc/gJmDN1yC/3.png)](https://postimg.cc/DWpLzjM6)

##### 3. SQL-запрос для выдачи списка пользователей с правами над таблицами test_db и вывод ответа
```shell
# Выводим список пользователей имеющих какой либо доступ к таблицам test_db (учитывает служебные таблицы)
docker exec -u postgres $CONTAINER_NAME psql -d $DB_NAME -c "SELECT DISTINCT grantee FROM information_schema.table_privileges;"
```
[![4.png](https://i.postimg.cc/tCssgmkd/4.png)](https://postimg.cc/YhwrnRJj)

### 3. Используя SQL синтаксис - наполните таблицы следующими тестовыми данными.
```shell
#  Наполняем таблицы данными
docker exec -u postgres $CONTAINER_NAME psql -d $DB_NAME -a -f "/var/lib/postgresql/scheme/insert.sql"
```
[![6.png](https://i.postimg.cc/HnQxXjZQ/6.png)](https://postimg.cc/4HxsT4Td)

```postgresql
-- insert.sql

INSERT INTO orders (product_name, price) VALUES ('Шоколад', 10),
                          ('Принтер', 3000),
                          ('Книга', 500),
                          ('Монитор', 7000),
                          ('Гитара', 4000);

INSERT INTO clients (last_name, country) VALUES ('Иванов Иван Иванович', 'USA'),
                          ('Петров Петр Петрович', 'Canada'),
                          ('Иоганн Себастьян Бах', 'Japan'),
                          ('Ронни Джеймс Дио', 'Russia'),
                          ('Ritchie Blackmore', 'Russia');
```

### 4. Используя foreign keys свяжите записи из таблиц.
```shell
# Наполняем таблицы данными
docker exec -u postgres $CONTAINER_NAME psql -d $DB_NAME -a -f "/var/lib/postgresql/scheme/update.sql"
# Выводим всех пользователей, которые совершили заказ
docker exec -u postgres $CONTAINER_NAME psql -d $DB_NAME -c "SELECT full_name FROM clients WHERE order_id IS NOT NULL;"
```
[![7.png](https://i.postimg.cc/1tBpxm1c/7.png)](https://postimg.cc/cgKKwNHr)

```postgresql
-- update.sql

UPDATE clients SET order_id = (SELECT id FROM orders WHERE product_name = 'Книга')
WHERE full_name = 'Иванов Иван Иванович';

UPDATE clients SET order_id = (SELECT id FROM orders WHERE product_name = 'Монитор')
WHERE full_name = 'Петров Петр Петрович';

UPDATE clients SET order_id = (SELECT id FROM orders WHERE product_name = 'Гитара')
WHERE full_name = 'Иоганн Себастьян Бах';
```

### 5. Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).
```shell
docker exec -u postgres $CONTAINER_NAME psql -d $DB_NAME -c "EXPLAIN SELECT full_name FROM clients WHERE order_id IS NOT NULL;"
```
[![8.png](https://i.postimg.cc/gj9rB1nq/8.png)](https://postimg.cc/Q9bXF4gH)

Вывод данной команды говорит нам о том, что мы последовательно читаем данные блок за блоком из нашей таблицы (метод - `Seq Scan`). Затраты на получение первой строки составляет 0.00 (`cost=0.00`). Затраты на получение всех строк составили (`13.00`). Приблизительно вернется 298 строк (`rows=298`, что не совсем понятно, откуда такое огромное число) и средний разммер каждой строки в байтах составит 118 (`width=118`).

### 6. Создайте бэкап БД test_db и восстановите его.
```shell
# Даём права на запись контейнеру в каталог backup 
sudo chown 999:$USER /home/irobot/Development/Study/devops/devops-netology/lesson_6.2/backup
# Создаём бэкап
docker exec -u postgres $CONTAINER_NAME sh -c "pg_dump $DB_NAME > /var/lib/postgresql/backup/backup.sql"
# Останавливаем и удаляем контейнер
docker-compose down
# Удаляем БД
sudo rm -rf /home/irobot/Development/Study/devops/devops-netology/lesson_6.2/data/*
# Поднимаем новый контейнер
docker-compose up -d
# Восстанавливаем БД из бэкапа
docker exec -u postgres $CONTAINER_NAME sh -c "pg_dump $DB_NAME < /var/lib/postgresql/backup/backup.sql"
```
