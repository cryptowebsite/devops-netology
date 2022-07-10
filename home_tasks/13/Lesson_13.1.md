# Lesson 13.1

## 1. Подготовить тестовый конфиг для запуска приложения
```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  labels:
    app: my-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: frontend
        image: cryptodeveloper/netology-frontend:v0.1.0
        imagePullPolicy: IfNotPresent
        ports:
        - name: web
          containerPort: 80
      - name: backend
        image: cryptodeveloper/netology-backend:v0.1.0
        imagePullPolicy: IfNotPresent
        ports:
        - name: api
          containerPort: 9000
---
apiVersion: v1
kind: Service
metadata:
  name: my-app-service
  namespace: default
spec:
  ports:
    - name: web
      port: 80
  selector:
    app: my-app        
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: my-app-db
  namespace: default
  labels:
    app: my-app-db
spec:
  serviceName: "my-app-db"
  replicas: 1
  podManagementPolicy: "Parallel"
  updateStrategy:
    type: "RollingUpdate"
  selector:
    matchLabels:
      app: my-app-db
  template:
    metadata:
      labels:
        app: my-app-db
    spec:
      containers:
        - name: my-app-db
          image: "postgres:14.4"
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
          volumeMounts:
            - name: db-data
              mountPath: /var/lib/postgresql/data
              readOnly: false
          resources:
            limits:
              cpu: "1"
              memory: 1Gi
            requests:
              cpu: 200m
              memory: 1000Mi

  volumeClaimTemplates:
  - metadata:
      name: db-data
    spec:
      storageClassName: db-class
      accessModes:
        - ReadWrite
      resources:
        requests:
          storage: "100Gi"
```

## 2. Подготовить конфиг для production окружения
```yaml
---
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
apiVersion: v1
kind: Service
metadata:
  name: frontend-service
  namespace: default
spec:
  ports:
    - name: web
      port: 80
  selector:
    app: frontend 
---
apiVersion: v1
kind: Service
metadata:
  name: backend-service
  namespace: default
spec:
  ports:
    - name: api
      port: 9000
  selector:
    app: backend  
```
