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