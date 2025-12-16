resource "azurerm_virtual_network" "vnet" {
  name                = "kaan-vnet"
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "default_sn" {
  name                 = "kaan-sn"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.10.0/24"]
}

resource "azurerm_subnet" "aks_sn" {
  name                 = "aks-sn"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.20.0/24"]
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.project_name}-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.project_name}aksdns99"

  default_node_pool {
    name                        = "default"
    node_count                  = var.aks_node_count
    vm_size                     = var.aks_vm_size
    auto_scaling_enabled        = var.aks_auto_scaling_enabled
    min_count                   = var.aks_min_count
    max_count                   = var.aks_max_count
    vnet_subnet_id              = azurerm_subnet.aks_sn.id
    temporary_name_for_rotation = "akstemporar"
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
# ACR role assigned to AKS
#########################
resource "azurerm_role_assignment" "acr_pull_assignment" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  # principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
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