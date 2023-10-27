output "result" {
  value = {
    values = {
      server = ""
      database = ""
      port = ""
      username = ""
    }
    secrets = {
      password = ""
      connectionString = ""
    }
    // https://docs.radapp.io/concepts/api-concept/#resource-ids
    resources = [
        "/planes/azure/azurecloud/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-group",
    ]
  }
  description = "The result of the Recipe. Must match the target resource's schema."
  sensitive = true
}