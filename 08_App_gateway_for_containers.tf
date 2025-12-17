resource "azurerm_public_ip" "appgw_public_ip" {
  name                = "${var.project_name}-appgw-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

locals {
  prefix                         = "appgw"
  backend_address_pool_name      = "${local.prefix}-beap"
  frontend_port_name             = "${local.prefix}-feport"
  frontend_ip_configuration_name = "${local.prefix}-feip"
  http_setting_name              = "${local.prefix}-be-htst"
  listener_name                  = "${local.prefix}-httplstn"
  request_routing_rule_name      = "${local.prefix}-rqrt"
  redirect_configuration_name    = "${local.prefix}-rdrcfg"
}

resource "azurerm_application_gateway" "network" {
  name                = "${var.project_name}-appgateway"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appgw-ip-configuration"
    subnet_id = azurerm_subnet.appgw_sn.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appgw_public_ip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  lifecycle {
    ignore_changes = [
      backend_address_pool,
      backend_http_settings,
      http_listener,
      request_routing_rule,
      probe,
      url_path_map
    ]
  }
}

#####################
# Outputs
#####################
output "Application_Gateway_Frontend_IP_Adress" {
  value = azurerm_public_ip.appgw_public_ip.ip_address
}