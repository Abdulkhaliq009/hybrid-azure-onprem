terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }
  }
  required_version = ">= 1.5.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

module "vpn" {
  source              = "./modules/vpn"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  onprem_public_ip    = var.onprem_public_ip
  onprem_address_space = var.onprem_address_space
}

module "appservice" {
  source              = "./modules/appservice"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  vnet_id             = module.vpn.vnet_id
  subnet_id           = module.vpn.appservice_subnet_id
  db_host             = var.onprem_db_host
  db_name             = var.db_name
  db_user             = var.db_user
  db_password         = var.db_password
}

module "frontdoor" {
  source              = "./modules/frontdoor"
  resource_group_name = azurerm_resource_group.main.name
  app_service_hostname = module.appservice.hostname
}
