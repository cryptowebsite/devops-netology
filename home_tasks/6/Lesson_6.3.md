# Lesson 6.3

### 1. Используя docker поднимите инстанс MySQL.
```yaml
# docker-compose.yml

version: '3.9'

services:
  db:
    container_name: ${CONTAINER_NAME}
    image: mysql:8
    command: --default-authentication-plugin=mysql_native_password
    volumes:
      - /home/irobot/Development/Study/devops/devops-netology/lesson_6.3/data:/var/lib/mysql
      - /home/irobot/Development/Study/devops/devops-netology/lesson_6.3/scheme:/var/lib/cnf
    restart: always
    ports:
      - "3306:3306"
    environment:
      MYSQL_ROOT_PASSWORD: ${$MYSQL_ROOT_PASSWORD}
```

```shell
# Поднимаем контейнер
. ./setenv.sh && docker-compose up -d

# Восстанавливаем БД
docker exec -i $CONTAINER_NAME sh -c "exec mysql -uroot -p$MYSQL_ROOT_PASSWORD $DB_NAME" < ./scheme/test_dump.sql

# Переходим в консоль mysql
docker exec -it $CONTAINER_NAME mysql -uroot -p"$MYSQL_ROOT_PASSWORD"
```
```mysql
# Смотрим версию сервера
\s
# ...
Server version:         8.0.27 MySQL Community Server - GPL
# ...

# Подключаемся к нашей БД
USE testdb;

# Получаем список таблиц нашей БД
SHOW TABLES;
# +------------------+
# | Tables_in_testdb |
# +------------------+
# | orders           |
# +------------------+
# 1 row in set (0.00 sec)

# Выводим количество записей с price > 300
SELECT COUNT(*) FROM orders WHERE price > 300;
# +----------+
# | COUNT(*) |
# +----------+
# |        1 |
# +----------+
# 1 row in set (0.00 sec)
```

### 2. Создайте пользователя test в БД c паролем test-pass. Предоставьте привелегии пользователю test на операции SELECT базы `test_db`.
```mysql
# Создаем локального пользователя test
CREATE USER `test`@`localhost`
  IDENTIFIED WITH caching_sha2_password BY 'test-pass'
  WITH MAX_QUERIES_PER_HOUR 100
  PASSWORD EXPIRE INTERVAL 180 DAY
  FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 2
  ATTRIBUTE '{"fname": "James", "lname": "Pretty"}';

# Даём права пользователю test на операции SELECT
GRANT SELECT ON testdb.* TO `test`@`localhost`;

# Получаем данные о пользователе test
SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE user='test';
# +------+-----------+---------------------------------------+
# | USER | HOST      | ATTRIBUTE                             |
# +------+-----------+---------------------------------------+
# | test | localhost | {"fname": "James", "lname": "Pretty"} |
# +------+-----------+---------------------------------------+
# 1 row in set (0.01 sec)
```

### 3. Какой `engine` используется в таблице БД `test_db`. Измените `engine` и приведите время выполнения и запрос на изменения из профайлера в ответе.
```mysql
# Смотрим какой движок используется в таблице orders
SHOW CREATE TABLE orders;

# Выходим из консоли mysql
\q
```

```shell
# Создаем новый дамп файл, путем копирования прежнего и изменения в нем движка и названия таблицы.
cp ./scheme/test_dump.sql ./scheme/test_dump2.sql
nano ./scheme/test_dump2.sql

# Восстанавливаем новую таблицу с новым движком
docker exec -i $CONTAINER_NAME sh -c "exec mysql -uroot -p$MYSQL_ROOT_PASSWORD $DB_NAME" < ./scheme/test_dump2.sql

# Переходим в консоль mysql
docker exec -it $CONTAINER_NAME mysql -uroot -p"$MYSQL_ROOT_PASSWORD"
```

```mysql
# Выбираем нашу базу
USE testdb;

# Включаем профилирование
SET profiling = 1;
SELECT * FROM orders;
SELECT * FROM orders2;

# Смотрим скорость выполнения
SHOW PROFILES;

# +----------+------------+-----------------------+
# | Query_ID | Duration   | Query                 |
# +----------+------------+-----------------------+
# |        1 | 0.00015800 | SELECT * FROM orders  |
# |        2 | 0.00051900 | SELECT * FROM orders2 |
# +----------+------------+-----------------------+
```

P.S. Для более компактного представления, обрезал вывод последней команды до двух, интересующих нас запросов. Очевидно что запрос выполнился, на движке `InnoDB`, примерно в 3 раза быстрее чем на `MyISAM`.

### 4. Измените файл `my.cnf` согласно ТЗ (движок InnoDB).
```
# /etc/mysql/my.cnf

[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

innodb_flush_method=O_DSYNC
innodb_file_per_table=1
innodb_log_buffer_size=1M
innodb_log_file_size=100M
innodb_buffer_pool_size=30%

!includedir /etc/mysql/conf.d/
```

P.S. в 4-ом задание при выставление `innodb_buffer_pool_size` в процентном соотношение, получаю ошибку `Unknown suffix '%' used for variable 'innodb-buffer-pool-size' (value '30%')`. Но когда выставляю фиксированное значение, например `1G`, то конфиг применяется отлично.
