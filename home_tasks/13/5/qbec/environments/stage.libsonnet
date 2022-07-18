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
