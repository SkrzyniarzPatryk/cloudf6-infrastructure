resource "azurerm_container_registry" "acr" {
  name                = "${var.project_name}containerregistry123"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false

  tags = var.common_tags
}