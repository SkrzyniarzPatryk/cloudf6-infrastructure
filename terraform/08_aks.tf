module "aks_and_appgw" {
  source = "./modules/kubernetes_service"

  project_prefix      = var.project_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.common_tags

  appgw_subnet_id    = var.agic_enabled ? azurerm_subnet.appgw_sn[0].id : null
  aks_node_subnet_id = azurerm_subnet.aks_sn.id

  agic_enabled = var.agic_enabled

  acr_id = azurerm_container_registry.acr.id

  # node pool settings
  aks_node_count                  = var.aks_node_count
  aks_vm_size                     = var.aks_vm_size
  aks_auto_scaling_enabled        = var.aks_auto_scaling_enabled
  aks_min_count                   = var.aks_min_count
  aks_max_count                   = var.aks_max_count
  aks_temporary_name_for_rotation = var.aks_temporary_name_for_rotation
}