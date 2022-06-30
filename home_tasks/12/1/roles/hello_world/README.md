Hello world role
=========

Роль для установки minikube на хостах с ОС: Debian, Ubuntu.

Requirements
------------

Поддерживаются только ОС семейств debian.

| Variable name | Default | Description                                                      |
|---------------|---------|------------------------------------------------------------------|
| app_port      | 8080    | Параметр, который определяет номер порта приложения hello-world |

Example Playbook
----------------

    - hosts: all
      roles:
         - ./roles/hello_world

License
-------

BSD

Author Information
------------------

Aleksandr Khaikin

Company Information
------------------

Netology