locals {
  name = sha512(var.context.resource.id)
  tags = {
    "managed_by" = "radius"
    "repo"       = "radius-demo"
  }
}

data "azurerm_client_config" "current" {}


resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.name}"
  location = "EastUS"
  tags     = local.tags
}

resource "azurerm_mssql_server" "this" {
  name                         = "sqlserver-${local.name}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "adminuser"
  administrator_login_password = uuid()

  lifecycle {
    ignore_changes = [ 
        "administrator_login_password"
     ]
  }
}

resource "azurerm_mssql_database" "this" {
  name           = local.name
  server_id      = azurerm_mssql_server.this.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"

  read_scale     = true
  sku_name       = "S0"
  zone_redundant = false

  tags = local.tags
}