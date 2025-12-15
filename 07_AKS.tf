resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.project_name}-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.project_name}aksdns99"

  default_node_pool {
    name                 = "default"
    node_count           = var.aks_node_count
    vm_size              = var.aks_vm_size
    auto_scaling_enabled = var.aks_auto_scaling_enabled
    min_count            = var.aks_min_count
    max_count            = var.aks_max_count
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  tags = var.common_tags
}

#########################
# Outputs
#########################
output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}