# Lesson 13.2

## 1. 
```yaml
---


---
apiVersion: v1
kind: Service
metadata:
  name: fb-pod
  labels:
    app: fb
spec:
  type: NodePort
  ports:
  - port: 80
    nodePort: 30080
  selector:
    app: fb-pod

---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: db
spec:
  serviceName: db-svc
  selector:
    matchLabels:
      app: db
  replicas: 1
  template:
    metadata:
      labels:
        app: db
    spec:
      containers:
        - name: db
          image: myregistry/k8s-database:05.07.22
          env:
            - name: POSTGRES_PASSWORD
              value: postgres
            - name: POSTGRES_USER
              value: postgres
            - name: POSTGRES_DB
              value: news    
                          
---
apiVersion: v1
kind: Service
metadata:
  name: db
spec:
  selector:
    app: db
  type: NodePort
  ports:
    - port: 5432
      targetPort: 5432
```

## 2. 
```yaml

```
