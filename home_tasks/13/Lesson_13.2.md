# Lesson 13.2

## 1. Подключить для тестового конфига общую папку
```yaml
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
        volumeMounts:
        - mountPath: "/static"
          name: static  
      - name: backend
        image: cryptodeveloper/netology-backend:v0.1.0
        imagePullPolicy: IfNotPresent
        ports:
        - name: api
          containerPort: 9000
        volumeMounts:
        - mountPath: "/static"
          name: static   
      volumes:
        - name: static
          emptyDir: {}
```
```shell
kubectl exec my-app-6dff4f7555-7kxxp -c backend -- sh -c "echo '42' > /static/42.txt"
kubectl exec my-app-6dff4f7555-7kxxp -c frontend -- cat /static/42.txt

42
```

## 2. Подключить общую папку для прода
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
        volumeMounts:
        - mountPath: "/static"
          name: static    
      volumes:
      - name: static
        persistentVolumeClaim:
          claimName: pvc
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
        volumeMounts:
        - mountPath: "/static"
          name: static
      volumes:
      - name: static
        persistentVolumeClaim:
          claimName: pvc
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: pvc
spec:
  storageClassName: "nfs"
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 2Gi
```
```shell
kubectl exec backend-7b5c6d8fb-mjttr -c backend -- sh -c "echo '42' > /static/42.txt"
kubectl exec frontend-5f978bc988-sq45l -c frontend -- cat /static/42.txt

42
```
