# Lesson 12.4

## 1. Подготовить инвентарь kubespray

### `hosts.yaml`
```yaml
all:
  hosts:
    cp0:
      ansible_host: 10.10.80.13
    node0:
      ansible_host: 10.10.80.14
    node1:
      ansible_host: 10.10.80.15
    node2:
      ansible_host: 10.10.80.16
    node3:
      ansible_host: 10.10.80.17
  children:
    kube_control_plane:
      hosts:
        cp0:
    kube_node:
      hosts:
        node0:
        node1:
        node2:
        node3:
    etcd:
      hosts:
        cp0:
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}
  vars:
    ansible_user: user
```

### `~/.kube/config`
```yaml
piVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeU1EWXpNREE1TURRMU5sb1hEVE15TURZeU56QTVNRFExTmxvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ>
    server: https://51.250.76.193:6443
  name: cluster.local
contexts:
- context:
    cluster: cluster.local
    user: kubernetes-admin
  name: kubernetes-admin@cluster.local
current-context: kubernetes-admin@cluster.local
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURJVENDQWdtZ0F3SUJBZ0lJQmNTUjhmUmY4S2d3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TWpBMk16QXdPVEEwTlRaYUZ3MHlNekEyTXpBd09UQTBOVGRhTURReApGekFWQmdOVkJBb1REbk41YzNSbGJUcHRZWE4wWlhKek1Sa3dGd1lEVlFRREV4QnJkV0psY201bGRH>
    client-key-data: LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb3dJQkFBS0NBUUVBNmdEekpIZmZsUzB0ZjhmYnhEa3E0a3dReXhrb05jWGNZMGZKTkg0TGhEWVZ4dGVDCnJhSkpEVmxzYWtjZ0F0dlpOc0V5TVpMRzdPV0pZWE1uWjZWWXNnNW9tekt2TEhuVVFwZFJ3R2s4MDd4SHJtQVkKZ0lFU2FXY1R3VXUrVlUxNkVCRGVLSjZxRTJCcjIzQXY4eVoxWUR3SEhuVVY4MklWcERzMVpYUG1hUTl4>
```

### `k8s-cluster.yml`
```yaml
container_manager: containerd # Было по умолчанию
supplementary_addresses_in_ssl_keys: [51.250.76.193]
```
