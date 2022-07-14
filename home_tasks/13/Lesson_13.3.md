# Lesson 13.3

## 1. Проверить работоспособность каждого компонента
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  labels:
    app: frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: cryptodeveloper/netology-frontend:v0.1.0
        imagePullPolicy: IfNotPresent
        env:
          - name: BASE_URL
            value: http://localhost:9000
        ports:
        - name: web
          containerPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  labels:
    app: backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: cryptodeveloper/netology-backend:v0.1.0
        imagePullPolicy: IfNotPresent
        env:
          - name: DATABASE_URL
            value: postgres://postgres:postgres@db:5432/news
        ports:
        - name: api
          containerPort: 9000
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: db
  namespace: default
  labels:
    app: db
spec:
  serviceName: "my-app-db"
  replicas: 1
  podManagementPolicy: "Parallel"
  updateStrategy:
    type: "RollingUpdate"
  selector:
    matchLabels:
      app: db
  template:
    metadata:
      labels:
        app: db
    spec:
      containers:
        - name: db
          image: "postgres:13-alpine"
          env:
            - name: POSTGRES_PASSWORD
              value: postgres
            - name: POSTGRES_USER
              value: postgres
            - name: POSTGRES_DB
              value: news
          ports:
          - containerPort: 5432
            name: db
          imagePullPolicy: "IfNotPresent"
---
apiVersion: v1
kind: Service
metadata:
  name: db
spec:
  selector:
    app: db
  ports:
    - protocol: TCP
      port: 5432
---
apiVersion: v1
kind: Service
metadata:
  name: frontend
spec:
  selector:
    app: frontend
  ports:
    - protocol: TCP
      port: 80
---
apiVersion: v1
kind: Service
metadata:
  name: backend
spec:
  selector:
    app: backend
  ports:
    - protocol: TCP
      port: 9000
```

### `port-forward`
#### `Db`
```shell
kubectl port-forward statefulset.apps/db 5433:5432

Forwarding from 127.0.0.1:5432 -> 5432
Forwarding from [::1]:5432 -> 5432
Handling connection for 5432
```
```shell
psql -U postgres -d news -W -h 127.0.0.1

Password:

psql (12.11 (Ubuntu 12.11-0ubuntu0.20.04.1), server 14.4 (Debian 14.4-1.pgdg110+1))
WARNING: psql major version 12, server major version 14.
         Some psql features might not work.
Type "help" for help.

news=#
```
#### `Backend`
```shell
kubectl port-forward deploy/backend 9000:9000

Forwarding from 127.0.0.1:9000 -> 9000
Forwarding from [::1]:9000 -> 9000
Handling connection for 9000
```
```shell
curl 127.0.0.1:9000

{"detail":"Not Found"}
```
#### `Frontend`
```shell
kubectl port-forward deploy/frontend 8080:80

Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
Handling connection for 8080
```
```shell
curl 127.0.0.1:8080

<!DOCTYPE html>
<html lang="ru">
<head>
    <title>Список</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/build/main.css" rel="stylesheet">
</head>
<body>
    <main class="b-page">
        <h1 class="b-page__title">Список</h1>
        <div class="b-page__content b-items js-list"></div>
    </main>
    <script src="/build/main.js"></script>
</body>
</html>
```

### `exec`
#### `Db`
```shell
kubectl exec --stdin --tty backend-5b996f6979-slc7f backend -- /bin/bash
apt -y update
apt-get install -y postgresql-client

psql -U postgres -d news -p 5432 -W -h db

Password: 
psql (11.16 (Debian 11.16-0+deb10u1), server 13.7)
WARNING: psql major version 11, server major version 13.
         Some psql features might not work.
Type "help" for help.
```
#### `Backend`
```shell
kubectl exec frontend-7b889cc9b7-d2gnt frontend -- sh -c 'curl backend:9000'

 % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    22  100    22    0     0   7333      0 --:--:-- --:--:-- --:--:--  7333{"detail":"Not Found"}
```
#### `Frontend`
```shell
kubectl exec backend-5b996f6979-slc7f backend -- sh -c 'curl frontend'

% Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   448  100   448    0     0   218k      0 --:--:-- --:--:-- --:--:--  218k
<!DOCTYPE html>
<html lang="ru">
<head>
    <title>Список</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/build/main.css" rel="stylesheet">
</head>
<body>
    <main class="b-page">
        <h1 class="b-page__title">Список</h1>
        <div class="b-page__content b-items js-list"></div>
    </main>
    <script src="/build/main.js"></script>
</body>
</html>
```

## 2. Ручное масштабирование
```shell
kubectl scale --replicas=3 deploy/frontend

deployment.apps/frontend scaled
```
```shell
kubectl scale --replicas=3 deploy/backend

deployment.apps/backend scaled
```
```shell
kubectl get pods -o wide

NAME                        READY   STATUS    RESTARTS   AGE   IP            NODE    NOMINATED NODE   READINESS GATES
backend-5b996f6979-kl7hl    1/1     Running   0          75s   10.233.94.5   node0   <none>           <none>
backend-5b996f6979-mqfd8    1/1     Running   0          74s   10.233.94.6   node0   <none>           <none>
backend-5b996f6979-slc7f    1/1     Running   0          51m   10.233.90.2   node1   <none>           <none>
db-0                        1/1     Running   0          51m   10.233.94.4   node0   <none>           <none>
frontend-7b889cc9b7-d2gnt   1/1     Running   0          51m   10.233.94.2   node0   <none>           <none>
frontend-7b889cc9b7-fxqhl   1/1     Running   0          78s   10.233.90.4   node1   <none>           <none>
frontend-7b889cc9b7-hjv89   1/1     Running   0          78s   10.233.90.3   node1   <none>           <none>
multitool-bfdff7d4c-xqhnb   1/1     Running   0          51m   10.233.94.3   node0   <none>           <none>
```
