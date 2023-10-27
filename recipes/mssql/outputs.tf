output "result" {
  value = {
    values = {
      server = azurerm_mssql_server.this.fully_qualified_domain_name
      database = azurerm_mssql_database.this.name
      port = "3389"
      username = "adminuser"
    }
    secrets = {
      password = "tbd"
      connectionString = "tbd"
    }
    // https://docs.radapp.io/concepts/api-concept/#resource-ids
    resources = [
        "/planes/azure/azurecloud/${azurerm_mssql_server.this.id}",
        "/planes/azure/azurecloud/${azurerm_mssql_database.this.id}",
    ]
  }
  description = "The result of the Recipe. Must match the target resource's schema."
  sensitive = true
}