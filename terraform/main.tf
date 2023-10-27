terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.77.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.1.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

locals {
  name = "raddemo${random_string.unique.result}"
  loc_for_naming = "eastus"
  tags = {
    "managed_by" = "terraform"
    "repo"       = "radius-demo"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.name}-${local.loc_for_naming}"
  location = local.loc_for_naming
}

resource "random_string" "unique" {
  length  = 8
  special = false
  upper   = false
}


data "azurerm_client_config" "current" {}

data "azurerm_log_analytics_workspace" "default" {
  name                = "DefaultWorkspace-${data.azurerm_client_config.current.subscription_id}-EUS"
  resource_group_name = "DefaultResourceGroup-EUS"
}

resource "azurerm_virtual_network" "default" {
  name                = "${local.name}-vnet-eastus"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]

  tags = local.tags
}


resource "azurerm_subnet" "default" {
  name                 = "default-subnet-eastus"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "cluster" {
  name                 = "${local.name}-subnet-eastus"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.1.0/24"]
}

data "azurerm_kubernetes_service_versions" "current" {
  location = azurerm_resource_group.rg.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                    = local.name
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  dns_prefix              = local.name
  kubernetes_version      = data.azurerm_kubernetes_service_versions.current.latest_version

  default_node_pool {
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_B4ms"
    os_disk_size_gb = "128"
    vnet_subnet_id  = azurerm_subnet.cluster.id
    upgrade_settings {
        max_surge = "10%"
    }
    tags = local.tags
  }

  network_profile {
    network_plugin      = "azure"
    network_policy      = "azure"
    network_plugin_mode = "overlay"
    service_cidr        = "10.255.252.0/22"
    dns_service_ip      = "10.255.252.10"
  }

  identity {
    type = "SystemAssigned"
  }
  
  oidc_issuer_enabled = true
  tags = local.tags
}


