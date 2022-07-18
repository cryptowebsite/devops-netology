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
