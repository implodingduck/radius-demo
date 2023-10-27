output "cluster_name" {
    value = azurerm_kubernetes_cluster.aks.name
}

output "cluster_rg" {
    value = azurerm_resource_group.rg.name
}

output "clluster_oidc_url" {
    value = azurerm_kubernetes_cluster.aks.oidc_issuer_url
}