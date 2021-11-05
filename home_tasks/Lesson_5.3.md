# Lesson 5.2

### 1. Опишите своими словами основные преимущества применения на практике IaaC паттернов. Какой из принципов IaaC является основополагающим?
* Основными преимуществами на мой взгляд являются: 
   * быстрое создание одинаковой среды (как аппаратной конфигурации, так и программного обеспечения) как в продакшене, так и для разработки с тестировкой. Что позволят разрабатывать в тех же условиях, как работает приложение в продакшене. 
   * позволяет удобно подготовить приложение к деплою и оправить его в репозиторий/сервер (CI/CD)
   * легкое масштабирование инфраструктуры
   * легкое отслеживание изменений и откат назад
* Основополагающим принципом `iaac` является `идемпотентность`. Это означает, что при выполнении (программы, функции и т.д.) с одинаковыми входными параметрами мы всегда получим одинаковый финальный результат.

### 2. Чем Ansible выгодно отличается от других систем управление конфигурациями? Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?
* Преимуществом `Ansible` являться отсутствием необходимости установки клиента на сервера т.к. все настройки происходят через `ssh`.
* На мой взгляд надёжней будет метод `pull` т.к. он выполняется локально.

### 3. Установить на личный компьютер: VirtualBox, Vagrant, Ansible
VirtualBox
```shell
virtualbox --help

Oracle VM VirtualBox VM Selector v6.1.26_Ubuntu
...
```
Vagrant
```shell
vagrant --version

Vagrant 2.2.18
```
Ansible
```shell
ansible --version

ansible [core 2.11.6] 
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/irobot/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  ansible collection location = /home/irobot/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.8.10 (default, Sep 28 2021, 16:10:42) [GCC 9.3.0]
  jinja version = 2.10.1
  libyaml = True
```

### 4. Создать виртуальную машину. Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды.
```shell
docker ps

CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

P.S. В четвертом задание пришлось обновить `Vagrant` с версии `2.2.6` на последнюю `2.2.18`, т.к. получал ошибку `Vagrant gathered an unknown Ansible version`. Как оказалось стейбл версия ни есть стейбл, а самая новая как раз стейбл =)