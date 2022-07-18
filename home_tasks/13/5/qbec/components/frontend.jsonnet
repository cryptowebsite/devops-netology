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