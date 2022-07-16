# Lesson 13.4

```text
# netology/templates/NOTES.txt

---------------------------------------------------------

Deployed version {{ .Chart.AppVersion }}

---------------------------------------------------------
```
```yaml
# netology/Chart.yaml

apiVersion: v2
name: netology
description: Lesson 13.4
type: application
version: "0.1.0"
appVersion: "0.1.0"
```
```yaml
# netology/values.yaml

replicaCount: 1
namespace: app1
portFrontend: 80
portBackend: 9000
portDb: 5432

imageFrontend:
  repository: cryptodeveloper/netology-frontend
  tag: "v0.1.0"

imageBackend:
  repository: cryptodeveloper/netology-backend
  tag: "v0.1.0"

imageDb:
  repository: postgres
  tag: "13-alpine"
```
```yaml
# netology/templates/service.yaml

apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}-frontend
  namespace: {{ .Values.namespace }}
  labels:
    app: {{ .Release.Name }}-frontend
spec:
  ports:
    - port: {{ .Values.portFrontend }}
      name: web
  selector:
    app: {{ .Release.Name }}-frontend
---
apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}-backend
  namespace: {{ .Values.namespace }}
  labels:
    app: {{ .Release.Name }}-backend
spec:
  ports:
    - port: {{ .Values.portBackend }}
      name: api
  selector:
    app: {{ .Release.Name }}-backend
---
apiVersion: v1
kind: Service
metadata:
  name: {{ .Release.Name }}-db
  namespace: {{ .Values.namespace }}
  labels:
    app: {{ .Release.Name }}-db
spec:
  ports:
    - port: {{ .Values.portDb }}
      name: psql
  selector:
    app: {{ .Release.Name }}-db
```
```yaml
# netology/templates/statefulset.yaml

apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: {{ .Release.Name }}-db
  namespace: {{ .Values.namespace }}
  labels:
    app: {{ .Release.Name }}-db
spec:
  serviceName: "db"
  replicas: 1
  podManagementPolicy: "Parallel"
  updateStrategy:
    type: "RollingUpdate"
  selector:
    matchLabels:
      app: {{ .Release.Name }}-db
  template:
    metadata:
      labels:
        app: {{ .Release.Name }}-db
    spec:
      containers:
        - name: db
          image: "{{ .Values.imageDb.repository }}:{{ .Values.imageDb.tag | default .Chart.AppVersion }}"
          env:
            - name: POSTGRES_PASSWORD
              value: postgres
            - name: POSTGRES_USER
              value: postgres
            - name: POSTGRES_DB
              value: news
          ports:
          - containerPort:  {{ .Values.portDb }}
            name: db
          imagePullPolicy: "IfNotPresent"
```
```yaml
# netology/templates/deployment.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-frontend
  namespace: {{ .Values.namespace }}
  labels:
    app: {{ .Release.Name }}-frontend
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: {{ .Release.Name }}-frontend
  template:
    metadata:
      labels:
        app: {{ .Release.Name }}-frontend
    spec:
      containers:
        - name: frontend
          image: "{{ .Values.imageFrontend.repository }}:{{ .Values.imageFrontend.tag | default .Chart.AppVersion }}"
          imagePullPolicy: IfNotPresent
          ports:
            - name: web
              containerPort:  {{ .Values.portFrontend }}
              protocol: TCP
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}-backend
  namespace: {{ .Values.namespace }}
  labels:
    app: {{ .Release.Name }}-backend
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: {{ .Release.Name }}-backend
  template:
    metadata:
      labels:
        app: {{ .Release.Name }}-backend
    spec:
      containers:
        - name: backend
          image: "{{ .Values.imageBackend.repository }}:{{ .Values.imageBackend.tag | default .Chart.AppVersion }}"
          imagePullPolicy: IfNotPresent
          ports:
            - name: api
              containerPort: {{ .Values.portBackend }}
              protocol: TCP
```
```shell
kubectl create ns app1
kubectl create ns app2
```

## 1. Подготовить helm чарт для приложения

```shell
helm -n app1 install netology netology

NAME: netology
LAST DEPLOYED: Sat Jul 16 14:39:26 2022
NAMESPACE: app1
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
---------------------------------------------------------

Deployed version 0.1.0

---------------------------------------------------------
```
```shell
sed -i 's/appVersion: "0.1.0"/appVersion: "0.2.0"/' netology/Chart.yaml
helm -n app1 upgrade netology netology

Release "netology" has been upgraded. Happy Helming!
NAME: netology
LAST DEPLOYED: Sat Jul 16 14:42:03 2022
NAMESPACE: app1
STATUS: deployed
REVISION: 2
TEST SUITE: None
NOTES:
---------------------------------------------------------

Deployed version 0.2.0

---------------------------------------------------------
```

## 2. Запустить 2 версии в разных неймспейсах
```shell
sed -i 's/appVersion: "0.2.0"/appVersion: "0.3.0"/' netology/Chart.yaml
sed -i 's/name: netology/name: netology-beta/' netology/Chart.yaml
helm -n app1 install netology-beta netology

NAME: netology-beta
LAST DEPLOYED: Sat Jul 16 16:17:23 2022
NAMESPACE: app1
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
---------------------------------------------------------

Deployed version 0.3.0

---------------------------------------------------------
```
```shell
sed -i 's/appVersion: "0.3.0"/appVersion: "0.4.0"/' netology/Chart.yaml
helm -n app2 install --set namespace=app2 netology netology

NAME: netology
LAST DEPLOYED: Sat Jul 16 16:17:43 2022
NAMESPACE: app2
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
---------------------------------------------------------

Deployed version 0.4.0

---------------------------------------------------------
```
```shell
helm list -A

NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART                   APP VERSION
netology        app1            2               2022-07-16 16:16:26.029981158 +0700 +07 deployed        netology-0.1.0          0.2.0      
netology        app2            1               2022-07-16 16:17:43.90464732 +0700 +07  deployed        netology-beta-0.1.0     0.4.0      
netology-beta   app1            1               2022-07-16 16:17:23.526966941 +0700 +07 deployed        netology-beta-0.1.0     0.3.0 
```
