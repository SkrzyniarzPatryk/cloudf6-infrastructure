terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.56.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  project       = "aksapp"
  location      = "West Europe"
  tags = {
    project     = "static-website"
    purpose     = "backend-storage"
    environment = "dev"
    owner       = "Patryk"
  }
}

resource "azurerm_resource_group" "tf_backend_rg" {
  name     = "${local.project}-backend-storage"
  location = local.location
  tags     = local.tags
}

resource "azurerm_storage_account" "tf_backend_sa" {
  name                     = "${local.project}tfstate"
  resource_group_name      = azurerm_resource_group.tf_backend_rg.name
  location                 = azurerm_resource_group.tf_backend_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version = "TLS1_2"
  tags            = local.tags
}

resource "azurerm_storage_container" "tf_state_container" {
  name                  = "tfstate"
  storage_account_id  = azurerm_storage_account.tf_backend_sa.id
  container_access_type = "private"
}

output "storage_account_name" {
  value       = azurerm_storage_account.tf_backend_sa.name
  description = "Storage account name for backend."
}

output "storage_container_name" {
  value       = azurerm_storage_container.tf_state_container.name
  description = "Container name for state files"
}