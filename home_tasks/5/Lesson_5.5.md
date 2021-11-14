# Lesson 5.5

### 1. В чём отличие режимов работы сервисов в Docker Swarm кластере: `replication` и `global`? Какой алгоритм выбора лидера используется в Docker Swarm кластере? Что такое Overlay Network?
* В режиме `replication` сервис будет запущен в том количестве нод, которое мы укажем. В режиме `global` сервис будет запущен на всех нодах в кластере.
* Для выбора лидера в Docker Swarm кластере используется алгоритм `Raft`.
* `Overlay Network` - это сеть создаваемая поверх другой сети.

### 2. Создать ваш первый Docker Swarm кластер в Яндекс.Облаке
[![Lesson-5-5-2.png](https://i.postimg.cc/NM9XcYg2/Lesson-5-5-2.png)](https://postimg.cc/cgWCRptd)

### 3. Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.
[![Lesson-5-5-3.png](https://i.postimg.cc/bvKJ1nhd/Lesson-5-5-3.png)](https://postimg.cc/XZk4bpX0)

### 4. Выполнить на лидере Docker Swarm кластера команду и дать письменное описание её функционала, что она делает и зачем она нужна.
Каждая нода использует два типа ключей шифрования. Первый тип ключей шифрует соединений между узлами. Второй тип ключей шифрует журналы, хранящиеся локально на каждой ноде, используемые протоколом `Raft` для выбора лидера. Команда `docker swarm update --autolock=true` позволяет зашифровать эти два ключа другим ключом, для дополнительной безопасности. Соответственно при перезагрузке ноды нужно ввести ключ расшифровки наших ключей для успешной работы ноды. На сколько я понял процесс напоминает перезагрузку сервера с шифрованными дисками, и потопал админ в серверную вбивать огромный пароль с физического терминала =). 




```shell
sudo docker swarm update --autolock=true

NAME               SERVICES   ORCHESTRATOR
swarm_monitoring   8          Swarm
[centos@node01 ~]$ sudo docker swarm update --autolock=true
Swarm updated.
To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-Whpgg3U4M0JjQxuEefbGhpoU6gShX5jqMrFe79oJkA0

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.
```
 

P.S. Так же как в прошлом д.з. пришлось исправить ошибку в блоках установки пакетов `yum`, а именно заменить `package` на `name` в файлах `ansible/roles/install-tools/tasks/main.yml` и `ansible/roles/docker-installation/tasks/main.yml`.