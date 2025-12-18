resource "azurerm_private_dns_zone" "private_dns" {
  name                = "javaserviceapppsqlflexserver.private.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_link" {
  name                  = "exampleVnetZone.com"
  private_dns_zone_name = azurerm_private_dns_zone.private_dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  resource_group_name   = azurerm_resource_group.rg.name
  depends_on            = [azurerm_subnet.db_sn]
}

resource "azurerm_postgresql_flexible_server" "psql_server" {
  name                          = "javaserviceapppsqlflexserver"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  version                       = "16"
  delegated_subnet_id           = azurerm_subnet.db_sn.id
  private_dns_zone_id           = azurerm_private_dns_zone.private_dns.id
  public_network_access_enabled = false
  administrator_login           = "psqladmin"
  administrator_password        = "H@Sh1CoR3!" 
  zone                          = "3"

  storage_mb   = 32768 
  storage_tier = "P4"

  sku_name   = "B_Standard_B1ms"
  depends_on = [azurerm_private_dns_zone_virtual_network_link.private_dns_link]
}

resource "azurerm_postgresql_flexible_server_database" "psql_server" {
  name      = "payments"
  server_id = azurerm_postgresql_flexible_server.psql_server.id
  collation = "en_US.utf8"
  charset   = "UTF8"

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}