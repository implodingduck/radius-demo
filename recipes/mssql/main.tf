data "azurerm_client_config" "current" {}


resource "azurerm_resource_group" "rg" {
  name     = "rg-${sha512(var.context.resource.id)}"
  location = "EastUS"
  tags     = { "managed_by" = "radius", "repo" = "radius-demo" }
}
