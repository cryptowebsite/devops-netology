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
