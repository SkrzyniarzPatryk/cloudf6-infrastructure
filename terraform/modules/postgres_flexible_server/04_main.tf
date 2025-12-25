resource "azurerm_private_dns_zone" "private_dns" {
  name                = "${var.db_name}.private.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_link" {
  name                  = "exampleVnetZone.com"
  private_dns_zone_name = azurerm_private_dns_zone.private_dns.name
  virtual_network_id    = var.vnet_id
  resource_group_name   = var.resource_group_name
}

resource "azurerm_postgresql_flexible_server" "psql_server" {
  name                          = var.db_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  version                       = var.postgres_version
  delegated_subnet_id           = var.subnet_id
  private_dns_zone_id           = azurerm_private_dns_zone.private_dns.id
  public_network_access_enabled = var.public_access
  administrator_login           = var.login
  administrator_password        = var.password
  zone                          = var.zone

  storage_mb   = var.storage_mb
  storage_tier = var.storage_tier

  sku_name   = var.sku_name
  tags       = var.tags
  depends_on = [azurerm_private_dns_zone_virtual_network_link.private_dns_link]
}

resource "azurerm_postgresql_flexible_server_database" "psql_server" {
  for_each  = toset(var.databases_list) # iterate over list as a set
  name      = each.value
  server_id = azurerm_postgresql_flexible_server.psql_server.id
  collation = "en_US.utf8"
  charset   = "UTF8"

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}