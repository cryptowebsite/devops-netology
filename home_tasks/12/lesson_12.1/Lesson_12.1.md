# Lesson 12.1

## 1. Установить `Minikube` и `Kubectl`

### 1.0 Software
#### Устанавливаем необходимое ПО
```shell
apt install -y curl git docker.io conntrack
```

### 1.1 Kubectl
#### Загружаем дистрибутив Kubectl
```shell
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 43.5M  100 43.5M    0     0  9534k      0  0:00:04  0:00:04 --:--:-- 9534k
```
#### Делаем файл исполняемым
```shell
chmod +x ./kubectl
```
#### Перемещаем исполняемы файл в директорию из переменной окружения PATH.
```shell
mv ./kubectl /usr/local/bin/kubectl
```

### 1.2 Go
#### Загружаем дистрибутив Go
```shell
curl -LO https://go.dev/dl/go1.18.3.linux-amd64.tar.gz
```
#### Распаковываем и перемещаем исполняемый файл
```shell
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.3.linux-amd64.tar.gz
```
#### Добавляем путь в переменную PATH
```shell
export PATH=$PATH:/usr/local/go/bin
```

### 1.3 crictl
#### Устанавливаем версию crictl
```shell
VERSION="v1.24.1"
```
#### Загружаем дистрибутив crictl
```shell
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz

...
Saving to: 'crictl-v1.24.1-linux-amd64.tar.gz'

crictl-v1.24.1-linux-amd64.tar.gz  100%[===============================================================>]  13.87M  8.82MB/s    in 1.6s    

2022-06-26 08:37:58 (8.82 MB/s) - 'crictl-v1.24.1-linux-amd64.tar.gz' saved [14541015/14541015]
```
#### Распаковываем дистрибутив crictl
```shell
sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin

crictl
```
#### Удаляем архив crictl
```shell
rm -f crictl-$VERSION-linux-amd64.tar.gz
```

### 1.4 cri-dockerd
#### Загружаем дистрибутив cri-dockerd
```shell
git clone https://github.com/Mirantis/cri-dockerd.git

Cloning into 'cri-dockerd'...
remote: Enumerating objects: 6152, done.
remote: Counting objects: 100% (107/107), done.
remote: Compressing objects: 100% (67/67), done.
remote: Total 6152 (delta 47), reused 70 (delta 30), pack-reused 6045
Receiving objects: 100% (6152/6152), 23.97 MiB | 4.21 MiB/s, done.
Resolving deltas: 100% (3820/3820), don
```

#### Загружаем скрипт установщик cri-dockerd
```shell
wget https://storage.googleapis.com/golang/getgo/installer_linux

...
Saving to: 'installer_linux'

installer_linux                    100%[===============================================================>]   4.94M  5.86MB/s    in 0.8s    

2022-06-26 08:42:34 (5.86 MB/s) - 'installer_linux' saved [5179246/5179246]
```
#### Делаем файл исполняемым
```shell
chmod +x ./installer_linux
```
#### Запускаем скрипт установщик
```shell
./installer_linux

...
Downloaded!
Setting up GOPATH
GOPATH has been set up!

One more thing! Run `source /root/.bash_profile` to persist the
new environment variables to your current session, or open a
new shell prompt.
```
#### Считавшем переменные окружения
```shell
source ~/.bash_profile
```
#### Переходим в директорию с дистрибутивом
```shell
cd cri-dockerd
```
#### Создаем новую в директорию
```shell
mkdir bin
```
#### Загружаем зависимости и собираем пакет
```shell
go get && go build -o bin/cri-dockerd

...
go: downloading github.com/matttproud/golang_protobuf_extensions v1.0.2-0.20181231171920-c182affec369
go: downloading google.golang.org/appengine v1.6.5
go: downloading github.com/coreos/pkg v0.0.0-20180928190104-399ea9e2e55f
go: downloading github.com/coreos/go-semver v0.3.0
```
#### Создаем новую в директорию
```shell
mkdir -p /usr/local/bin
```
#### Устанавливаем дистрибутив
```shell
install -o root -g root -m 0755 bin/cri-dockerd /usr/local/bin/cri-dockerd
```
#### Копируем init файлы
```shell
cp -a packaging/systemd/* /etc/systemd/system
```
#### Исправляем конфигурационный файл
```shell
sed -i -e 's,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd,' /etc/systemd/system/cri-docker.service
```
#### Пересчитываем конфиг systemd
```shell
systemctl daemon-reload
```
#### Добавляем демона в автозагрузку
```shell
systemctl enable cri-docker.service

Created symlink /etc/systemd/system/multi-user.target.wants/cri-docker.service → /etc/systemd/system/cri-docker.service.
```
#### Запускаем демона
```shell
systemctl enable --now cri-docker.socket
```

### 1.5 Minikube
#### Скачиваем дистрибутив и делаем файл исполняемым
```shell
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube
```
#### Создаем директорию
```shell
mkdir -p /usr/local/bin/
```
#### Устанавливаем дистрибутив
```shell
install minikube /usr/local/bin/
```

## 2. Запуск Hello World
#### Запускаем minikube
```shell
minikube start --vm-driver=none

...
💡  This can also be done automatically by setting the env var CHANGE_MINIKUBE_NONE_USER=true
🔎  Verifying Kubernetes components...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Enabled addons: default-storageclass, storage-provisioner
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
```
#### Устанавливаем аддон ingress
```shell
minikube addons enable ingress

...
🌟  The 'ingress' addon is enabled
```
#### Устанавливаем аддон dashboard
```shell
minikube addons enable dashboard

...
🌟  The 'dashboard' addon is enabled
```
#### Создаем deployment
```shell
kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4

deployment.apps/hello-node created
```
#### Создаем сервис
```shell
kubectl expose deployment hello-node --type=LoadBalancer --port=8080

service/hello-node exposed
```
#### Делаем форвард порта
```shell
kubectl port-forward deployment/hello-node 8080:8080

Forwarding from 127.0.0.1:8080 -> 8080
Forwarding from [::1]:8080 -> 8080
Handling connection for 8080
```
