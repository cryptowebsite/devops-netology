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
