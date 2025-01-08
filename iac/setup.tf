terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.14.0"
    }
  }

#   backend "azurerm" {
#     resource_group_name = "reference-rg"
#     storage_account_name = "demoiac"
#     container_name = "terraform"
#     key = "terraform.tfstate"
#   }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
