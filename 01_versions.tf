terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.56.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.7.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "aksapp-backend-storage"
    storage_account_name = "aksapptfstate"
    container_name       = "tfstate"
    key                  = "infrastructure.terraform.tfstate"
  }
}