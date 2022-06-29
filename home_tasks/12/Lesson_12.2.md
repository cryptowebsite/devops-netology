# Lesson 12.2

## 1. Запуск пода из образа в деплойменте
```shell
kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4 -r 2

deployment.apps/hello-node created
```
```shell
kubectl get deployment

NAME         READY   UP-TO-DATE   AVAILABLE   AGE
hello-node   2/2     2            2           43s
```
```shell
kubectl get pods

NAME                          READY   STATUS    RESTARTS   AGE
hello-node-6b89d599b9-4hv44   1/1     Running   0          104s
hello-node-6b89d599b9-5xqfq   1/1     Running   0          104s
```

## 2. Просмотр логов для разработки
```shell
kubectl create ns app-namespace

namespace/app-namespace created
```
```shell
kubectl -n app-namespace create serviceaccount netology

serviceaccount/netology created
```
```shell
kubectl -n app-namespace create role logs --resource=pods --verb=get,list,watch

role.rbac.authorization.k8s.io/logs created
```
```shell
kubectl -n app-namespace create rolebinding netology-log --role=logs --serviceaccount=app-namespace:netology

rolebinding.rbac.authorization.k8s.io/netology-log created
```
```shell
cat <<EOF | kubectl -n app-namespace apply -f -
apiVersion: v1
kind: Secret
type: kubernetes.io/service-account-token
metadata:
  name: netology-secret
  annotations:
    kubernetes.io/service-account.name: "netology"
EOF

secret/netology-secret created
```
```shell
kubectl -n app-namespace patch serviceaccount netology -p '{"imagePullSecrets": [{"name": "netology-secret"}]}'

serviceaccount/netology patched
```
```shell
TOKEN=`kubectl -n app-namespace get secret netology-secret -o jsonpath='{.data.token}'| base64 --decode`
```
```shell
kubectl config set-credentials netology --token $TOKEN

User "netology" set.
```
```shell
kubectl config set-context netology-context --cluster=minikube --namespace app-namespace --user netology

Context "netology-context" created
```
```shell
kubectl config use-context netology-context

Switched to context "netology-context".
```
```shell
kubectl describe pods/hello-node-6d5f754cc9-6nqgg

Name:         hello-node-6d5f754cc9-6nqgg
Namespace:    app-namespace
Priority:     0
Node:         minikube/192.168.49.2
Start Time:   Tue, 28 Jun 2022 13:48:48 +0000
Labels:       app=hello-node
              pod-template-hash=6d5f754cc9
Annotations:  <none>
Status:       Running
IP:           172.17.0.4
IPs:
  IP:           172.17.0.4
Controlled By:  ReplicaSet/hello-node-6d5f754cc9
Containers:
  echoserver:
    Container ID:   docker://473be09f0e5ec446f4dffb1b193c9b4b7479c6083050f4a5aa0c34966182975b
    Image:          k8s.gcr.io/echoserver:1.4
    Image ID:       docker-pullable://k8s.gcr.io/echoserver@sha256:5d99aa1120524c801bc8c1a7077e8f5ec122ba16b6dda1a5d3826057f67b9bcb
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Tue, 28 Jun 2022 13:48:50 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-kvhk4 (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  kube-api-access-kvhk4:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:                      <none>
```
```shell
kubectl auth can-i get pods

yes
```
```shell
kubectl create serviceaccount test --namespace app-namespace

error: failed to create serviceaccount: serviceaccounts is forbidden: User "system:serviceaccount:app-namespace:netology" cannot create resource "serviceaccounts" in API group "" in the namespace "app-namespace"
```

## 3. Изменение количества реплик
```shell
kubectl scale deployment hello-node --replicas 5

deployment.apps/hello-node scaled
```
```shell
kubectl get pods

NAME                          READY   STATUS    RESTARTS   AGE
hello-node-6b89d599b9-4hv44   1/1     Running   0          4m58s
hello-node-6b89d599b9-5xqfq   1/1     Running   0          4m58s
hello-node-6b89d599b9-8mnkq   1/1     Running   0          34s
hello-node-6b89d599b9-gjvdg   1/1     Running   0          34s
hello-node-6b89d599b9-npk5m   1/1     Running   0          34s
```