module "postgres_flexible_server" {
  source = "./modules/postgres_flexible_server"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.common_tags

  db_name          = var.postgres_db_name
  postgres_version = var.postgres_version
  storage_mb       = var.postgres_storage_mb
  storage_tier     = var.postgres_storage_tier
  sku_name         = var.postgres_sku_name
  zone             = var.postgres_zone

  login = var.postgres_admin_login
  password = var.postgres_admin_password

  public_access = false
  subnet_id = azurerm_subnet.db_sn.id
  vnet_id   = azurerm_virtual_network.vnet.id

  # List of databases to create
  databases_list = ["payments", "orders", "customers"]
}