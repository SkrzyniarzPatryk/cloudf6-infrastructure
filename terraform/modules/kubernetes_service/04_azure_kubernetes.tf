resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.project_prefix}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.project_prefix}aksdns99" #

  default_node_pool {
    name                        = "default"
    node_count                  = var.aks_node_count
    vm_size                     = var.aks_vm_size
    auto_scaling_enabled        = var.aks_auto_scaling_enabled
    min_count                   = var.aks_min_count
    max_count                   = var.aks_max_count
    vnet_subnet_id              = var.aks_node_subnet_id
    temporary_name_for_rotation = var.aks_temporary_name_for_rotation
  }

  identity {
    type = "SystemAssigned"
  }

  # dynamic block for AGIC
  dynamic "ingress_application_gateway" {
    for_each = var.agic_enabled ? [1] : []
    content {
      gateway_id = azurerm_application_gateway.network[0].id
    }
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      default_node_pool[0].upgrade_settings # ignore upgrade_settings
    ]
  }
}

#########################
# Role assignment for AKS
#########################
# ACR role assigned to AKS
resource "azurerm_role_assignment" "acr_pull_assignment" {
  count                = length(var.acr_id) > 0 ? 1 : 0 # only if ACR ID is provided
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}
# Role for AGIC to subnet contribute
resource "azurerm_role_assignment" "agic_subnet_permission" {
  count                = var.agic_enabled ? 1 : 0 # only if AGIC is enabled
  scope                = var.appgw_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
}
# Rolle for managing App Gateway by ingress AGIC
resource "azurerm_role_assignment" "agic_appgw_contributor" {
  count                = var.agic_enabled ? 1 : 0 # only if AGIC is enabled
  scope                = azurerm_application_gateway.network[0].id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
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