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
