# Lesson 12.5

## 1. Установить в кластер CNI плагин Calico

### Default
```yaml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
spec:
  podSelector: {}
  policyTypes:
    - Ingress
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-egress
spec:
  podSelector: {}
  policyTypes:
    - Egress
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-dns-access
spec:
  podSelector:
    matchLabels: {}
  policyTypes:
    - Egress
  egress:
    - ports:
      - protocol: UDP
        port: 53
```

### Frontend
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: frontend-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: frontend
  policyTypes:
  - Egress
  - Ingress
  ingress:
  - from:
      - ipBlock:
          cidr: 0.0.0.0/0
          except:
          - 10.233.64.0/18
    ports:
    - protocol: TCP
      port: 80
    - protocol: TCP
      port: 443
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: backend
    ports:
      - protocol: TCP
        port: 80
      - protocol: TCP
        port: 443
```

### Backend
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
    - Ingress
    - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend
    ports:
      - protocol: TCP
        port: 80
      - protocol: TCP
        port: 443
  egress: 
  - to:
    - podSelector:
        matchLabels:
          app: cache
    ports:
    - protocol: TCP
      port: 80
    - protocol: TCP
      port: 443  
```

### Cache
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: cache-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: cache
  policyTypes:
    - Ingress
    - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: backend
    ports:
      - protocol: TCP
        port: 80
      - protocol: TCP
        port: 443
  egress: 
  - {}
```

### Frontend test
```shell
kubectl exec frontend-c74c5646c-4z6bt -- curl -s -m 1 backend

Praqma Network MultiTool (with NGINX) - backend-869fd89bdc-k7d7w - 10.233.94.3
```
```shell
kubectl exec frontend-c74c5646c-4z6bt -- curl -s -m 1 cache

command terminated with exit code 28
```
### Backend test
```shell
kubectl exec backend-869fd89bdc-thv25 -- curl -s -m 1 frontend

command terminated with exit code 28
```
```shell
kubectl exec backend-869fd89bdc-thv25 -- curl -s -m 1 cache

Praqma Network MultiTool (with NGINX) - cache-b7cbd9f8f-kjn6b - 10.233.94.4
```
### Cache test
```shell
kubectl exec cache-b7cbd9f8f-z2p4d -- curl -s -m 1 frontend

command terminated with exit code 28
```
```shell
kubectl exec cache-b7cbd9f8f-z2p4d -- curl -s -m 1 backend

command terminated with exit code 28
```

## 2. Изучить, что запущено по умолчанию

```shell
calicoctl get nodes

NAME    
cp0     
node0
```

```shell
calicoctl get ipPool

NAME           CIDR             SELECTOR   
default-pool   10.233.64.0/18   all()
```

```shell
calicoctl get profile

NAME                                                 
projectcalico-default-allow                          
kns.default                                          
kns.kube-node-lease                                  
kns.kube-public                                      
kns.kube-system                                      
ksa.default.default                                  
ksa.kube-node-lease.default                          
ksa.kube-public.default                              
ksa.kube-system.attachdetach-controller              
ksa.kube-system.bootstrap-signer                     
ksa.kube-system.calico-node                          
ksa.kube-system.certificate-controller               
ksa.kube-system.clusterrole-aggregation-controller   
ksa.kube-system.coredns                              
ksa.kube-system.cronjob-controller                   
ksa.kube-system.daemon-set-controller                
ksa.kube-system.default                              
ksa.kube-system.deployment-controller                
ksa.kube-system.disruption-controller                
ksa.kube-system.dns-autoscaler                       
ksa.kube-system.endpoint-controller                  
ksa.kube-system.endpointslice-controller             
ksa.kube-system.endpointslicemirroring-controller    
ksa.kube-system.ephemeral-volume-controller          
ksa.kube-system.expand-controller                    
ksa.kube-system.generic-garbage-collector            
ksa.kube-system.horizontal-pod-autoscaler            
ksa.kube-system.job-controller                       
ksa.kube-system.kube-proxy                           
ksa.kube-system.namespace-controller                 
ksa.kube-system.node-controller                      
ksa.kube-system.nodelocaldns                         
ksa.kube-system.persistent-volume-binder             
ksa.kube-system.pod-garbage-collector                
ksa.kube-system.pv-protection-controller             
ksa.kube-system.pvc-protection-controller            
ksa.kube-system.replicaset-controller                
ksa.kube-system.replication-controller               
ksa.kube-system.resourcequota-controller             
ksa.kube-system.root-ca-cert-publisher               
ksa.kube-system.service-account-controller           
ksa.kube-system.service-controller                   
ksa.kube-system.statefulset-controller               
ksa.kube-system.token-cleaner                        
ksa.kube-system.ttl-after-finished-controller        
ksa.kube-system.ttl-controller
```