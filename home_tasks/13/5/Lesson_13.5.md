# Lesson 13.5

## 1. Подготовить приложение для работы через qbec

```jsonnet
//  qbec/components/frontend.jsonnet

local p = import '../params.libsonnet';
local params = p.components.frontend;
local prefix = p.environment + '-';

[
  {
    apiVersion: 'v1',
    kind: 'ConfigMap',
    metadata: {
      name: prefix + 'frontend',
    },
  },
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: prefix + 'frontend',
      labels: {
        app: prefix + 'frontend',
      },
    },
    spec: {
      replicas: params.replicas,
      selector: {
        matchLabels: {
          app: prefix + 'frontend',
        },
      },
      template: {
        metadata: {
          labels: {
            app: prefix + 'frontend',
          },
        },
        spec: {
          containers: [
            {
              name: 'frontend',
              image: 'cryptodeveloper/netology-frontend:v0.1.0',
              imagePullPolicy: 'Always',
            },
          ],
        },
      },
    },
  },
  {
    apiVersion: "v1",
    kind: "Service",
    metadata: {
      name: prefix + 'frontend'
    },
    spec: {
      selector: {
        app: prefix + 'frontend'
      },
      ports: [
        {
          name: "web",
          targetPort: 80,
          port: 80
        }
      ]
    }
  }
]
```
```jsonnet
//  qbec/components/backend.jsonnet

local p = import '../params.libsonnet';
local params = p.components.backend;
local prefix = p.environment + '-';

[
  {
    apiVersion: 'v1',
    kind: 'ConfigMap',
    metadata: {
      name: prefix + 'backend',
    },
  },
  {
    apiVersion: 'apps/v1',
    kind: 'Deployment',
    metadata: {
      name: prefix + 'backend',
      labels: {
        app: prefix + 'backend',
      },
    },
    spec: {
      replicas: params.replicas,
      selector: {
        matchLabels: {
          app: prefix + 'backend',
        },
      },
      template: {
        metadata: {
          labels: {
            app: prefix + 'backend',
          },
        },
        spec: {
          containers: [
            {
              name: 'backend',
              image: 'cryptodeveloper/netology-backend:v0.1.0',
              imagePullPolicy: 'Always',
            },
          ],
        },
      },
    },
  },
  {
    apiVersion: "v1",
    kind: "Service",
    metadata: {
      name: prefix + 'backend'
    },
    spec: {
      selector: {
        app: prefix + 'backend'
      },
      ports: [
        {
          name: "api",
          targetPort: 9000,
          port: 9000
        }
      ]
    }
  }
]
```
```jsonnet
//  qbec/components/db.jsonnet

local p = import '../params.libsonnet';
local params = p.components.db;
local prefix = p.environment + '-';

[
  {
    kind: "Deployment",
    apiVersion: "apps/v1",
    metadata: {
      name: prefix + "db"
    },
    spec: {
      replicas: params.replicas,
      selector: {
        matchLabels: {
          component: prefix + "db"
        }
      },
      template: {
        metadata: {
          labels: {
            component: prefix + "db"
          }
        },
        spec: {
          containers: [
            {
              name: "postgres",
              image: "postgres:13-alpine",
              env: [
                {
                  name: "POSTGRES_PASSWORD",
                  value: "postgres"
                },
                {
                  name: "POSTGRES_USER",
                  value: "postgres"
                },
                {
                  name: "POSTGRES_DB",
                  value: "news"
                }
              ]
            }
          ]
        }
      }
    }
  },
  {
    apiVersion: "v1",
    kind: "Service",
    metadata: {
      name: prefix + "db"
    },
    spec: {
      ports: [
        {
          name: "psql",
          targetPort: 5432,
          port: 5432
        }
      ]
    }
  }
]
```
```jsonnet
//  qbec/components/endpoint.jsonnet

local p = import '../params.libsonnet';
local params = p.components.frontend;
local prefix = p.environment + '-';

[
  {
    apiVersion: 'v1',
    kind: 'ConfigMap',
    metadata: {
      name: prefix + 'endpoint',
    },
  },
  {
    apiVersion: "v1",
    kind: "Endpoints",
    metadata: {
      name: prefix + 'db'
    },
    subsets: [
      {
        addresses: [
          {
            ip: "10.10.80.33"
          }
        ],
        ports: [
          {
            port: 5432,
            name: "psql"
          }
        ]
      }
    ]
  }
]
```
```jsonnet
//  qbec/environments/prod.libsonnet

{
  environment: "prod",
  components: {
    frontend: {
      replicas: 3,
    },
    backend: {
      replicas: 3,
    },
    db: {
      replicas: 3,
    },
  },
}
```
```jsonnet
//  qbec/environments/stage.libsonnet

{
  environment: "stage",
  components: {
    frontend: {
      replicas: 1,
    },
    backend: {
      replicas: 1,
    },
    db: {
      replicas: 1,
    },
  },
}
```
```jsonnet
//  qbec/params.libsinnet

local env = std.extVar('qbec.io/env');

local paramsMap = {
  stage: import './environments/stage.libsonnet',
  prod: import './environments/prod.libsonnet',
};

if std.objectHas(paramsMap, env) then paramsMap[env] else error 'environment ' + env + ' not defined in ' + std.thisFile
```
```yaml
//  qbec/qbec.yaml

apiVersion: qbec.io/v1alpha1
kind: App
metadata:
  name: netology
spec:
  environments:
    stage:
      defaultNamespace: qbec-stage
      server: https://10.10.80.13:6443
    prod:
      defaultNamespace: qbec-prod
      server: https://10.10.80.13:6443
      includes:
        - endpoint
  vars: {}
  excludes:
    - endpoint
```
```shell
kubectl -n qbec-prod get all

NAME                                READY   STATUS    RESTARTS   AGE
pod/prod-backend-5df9d57785-kgtxp   1/1     Running   0          76s
pod/prod-backend-5df9d57785-kvj7t   1/1     Running   0          76s
pod/prod-backend-5df9d57785-xl5hp   1/1     Running   0          76s
pod/prod-db-6d5b7c7f-8xrxf          1/1     Running   0          76s
pod/prod-db-6d5b7c7f-fcnb2          1/1     Running   0          76s
pod/prod-db-6d5b7c7f-gmjts          1/1     Running   0          76s
pod/prod-frontend-b7599c6bc-2q4dm   1/1     Running   0          76s
pod/prod-frontend-b7599c6bc-n7qgt   1/1     Running   0          76s
pod/prod-frontend-b7599c6bc-r97nh   1/1     Running   0          76s

NAME                    TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/prod-backend    ClusterIP   10.233.33.136   <none>        9000/TCP   76s
service/prod-db         ClusterIP   10.233.12.24    <none>        5432/TCP   75s
service/prod-frontend   ClusterIP   10.233.43.41    <none>        80/TCP     75s

NAME                            READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/prod-backend    3/3     3            3           76s
deployment.apps/prod-db         3/3     3            3           76s
deployment.apps/prod-frontend   3/3     3            3           76s

NAME                                      DESIRED   CURRENT   READY   AGE
replicaset.apps/prod-backend-5df9d57785   3         3         3       76s
replicaset.apps/prod-db-6d5b7c7f          3         3         3       76s
replicaset.apps/prod-frontend-b7599c6bc   3         3         3       76s
```
```shell
kubectl -n qbec-stage get all

NAME                                  READY   STATUS    RESTARTS   AGE
pod/stage-backend-df944999b-tx4kf     1/1     Running   0          76s
pod/stage-db-776ccc4c48-smzrl         1/1     Running   0          76s
pod/stage-frontend-68fcfb756d-ng8z5   1/1     Running   0          76s

NAME                     TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/stage-backend    ClusterIP   10.233.38.71    <none>        9000/TCP   76s
service/stage-db         ClusterIP   10.233.27.39    <none>        5432/TCP   75s
service/stage-frontend   ClusterIP   10.233.40.174   <none>        80/TCP     75s

NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/stage-backend    1/1     1            1           76s
deployment.apps/stage-db         1/1     1            1           76s
deployment.apps/stage-frontend   1/1     1            1           76s

NAME                                        DESIRED   CURRENT   READY   AGE
replicaset.apps/stage-backend-df944999b     1         1         1       76s
replicaset.apps/stage-db-776ccc4c48         1         1         1       76s
replicaset.apps/stage-frontend-68fcfb756d   1         1         1       76s
```
```shell
qbec component list prod

COMPONENT                      FILES
backend                        components/backend.jsonnet
db                             components/db.jsonnet
endpoint                       components/endpoint.jsonnet
frontend                       components/frontend.jsonnet
```
```shell
qbec component list stage

COMPONENT                      FILES
backend                        components/backend.jsonnet
db                             components/db.jsonnet
frontend                       components/frontend.jsonnet
```