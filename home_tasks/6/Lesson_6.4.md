# Lesson 6.4

### 1. Управляющие команды
```yaml
# docker-compose.yml

version: '3.9'
services:
   postgres:
     container_name: ${CONTAINER_NAME}
     image: postgres:13
     volumes:
       - /home/irobot/Development/Study/devops/devops-netology/lesson_6.4/data:/var/lib/postgresql/data
       - /home/irobot/Development/Study/devops/devops-netology/lesson_6.4/backup:/var/lib/postgresql/backup
     environment:
       POSTGRES_PASSWORD: ${POSTGRES_USER_PASSWORD}
       POSTGRES_DB: "postgres"
       POSTGRES_USER: "postgres"
       PGDATA: "/var/lib/postgresql/data"
     restart: always
     ports:
      - "5432:5432"
```

* `\l` - вывода списка БД
* `\c <db_name>` - подключения к БД
* `\dt` - вывода списка таблиц
* `\dt+` - вывода описания содержимого таблиц
* `\q` - выхода из psql

### 2. Создайте БД `test_database`. Восстановите бэкап БД. Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.
```shell
# Создаем БД test_database
docker exec -u postgres $CONTAINER_NAME createdb test_database

# Восстанавливаем БД из бэкапа
docker exec -u postgres $CONTAINER_NAME sh -c "psql test_database < /var/lib/postgresql/backup/test_dump.sql"

# Заходим в консоль postgres и подключаемся к БД
docker exec -it -u postgres $CONTAINER_NAME sh -c "psql -U postgres -d test_database"
```

```postgresql
-- Выполняем операцию ANALYZE
ANALYZE orders;

-- Выводим столбец таблицы orders с наибольшим средним значением размера элементов в байтах
SELECT attname FROM pg_stats WHERE tablename='orders' AND avg_width=(SELECT max(avg_width) from pg_stats WHERE tablename='orders');
```
[![1.png](https://i.postimg.cc/hjVH6McH/1.png)](https://postimg.cc/9RF8qd4p)

### 3. Предложите SQL-транзакцию для разбиения таблицы на 2. Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?
```postgresql
BEGIN;

CREATE TABLE orders_1 (
    CHECK ( price < 500 )
) INHERITS (orders);

CREATE TABLE orders_2 (
    CHECK ( price > 499 )
) INHERITS (orders);

SAVEPOINT tables_created;

CREATE RULE orders_insert_to_1 AS ON INSERT TO orders
WHERE ( price < 500 )
DO INSTEAD INSERT INTO orders_1 VALUES (NEW.*);

CREATE RULE orders_insert_to_2 AS ON INSERT TO orders
WHERE ( price > 499 )
DO INSTEAD INSERT INTO orders_2 VALUES (NEW.*);

SAVEPOINT rules_created;

INSERT INTO orders_1 (id, title, price) SELECT id, title, price FROM orders WHERE price < 500;
INSERT INTO orders_2 (id, title, price) SELECT id, title, price FROM orders WHERE price > 499;

SAVEPOINT data_copied;

DELETE FROM ONLY orders;

SAVEPOINT old_data_deleted;

COMMIT;
```

"Ручного" разбиения таблиц можно было бы избежать, если бы мы при проектировке БД заранее подумали о масштабирование и создали процедуру, которая будет при добавлении новой записи проверять условие и в зависимости от результата создавать новую или складывать в уже существующую таблицу.

### 4. Создать бекап БД `test_database` и доработать его так, чтобы столбец `title` стал уникальным.
```shell
# Даём права на запись контейнеру в каталог backup 
sudo chown 999:$USER /home/irobot/Development/Study/devops/devops-netology/lesson_6.4/backup

# Создаем бэкап
docker exec -u postgres $CONTAINER_NAME sh -c "pg_dump test_database > /var/lib/postgresql/backup/backup.sql"
```

Для добавления уникальности полю `title` нужно следующие два правила в конец бэкап-файла (после создания порционных таблиц). Конечно хотелось бы дописать лишь одно слово `UNIQUE` к полю `title` в момент создания основной таблицы, но порционные таблицы не наследуют ограничения.
```postgresql
ALTER TABLE ONLY public.orders_1
    ADD CONSTRAINT unique_title_1 UNIQUE(title);

ALTER TABLE ONLY public.orders_2
    ADD CONSTRAINT unique_title_2 UNIQUE(title);
```