terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
  required_version = ">= 1.5.0"
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

module "vpn" {
  source               = "./modules/vpn"
  resource_group_name  = azurerm_resource_group.main.name
  location             = var.location
  onprem_public_ip     = var.onprem_public_ip
  onprem_address_space = var.onprem_address_space
}

module "appservice" {
  source                        = "./modules/appservice"
  resource_group_name           = azurerm_resource_group.main.name
  location                      = var.location
  vnet_id                       = module.vpn.vnet_id
  subnet_id                     = module.vpn.appservice_subnet_id
  db_host                       = var.onprem_db_host
  db_name                       = var.db_name
  db_user                       = var.db_user
  db_password                   = var.db_password
  db_user_secret_uri            = module.keyvault.db_password_secret_uri
  db_password_secret_uri        = module.keyvault.db_password_secret_uri
  app_insights_connection_string = module.monitoring.app_insights_connection_string
}

module "keyvault" {
  source                      = "./modules/keyvault"
  resource_group_name         = azurerm_resource_group.main.name
  location                    = var.location
  app_service_principal_id    = module.appservice.principal_id
  private_endpoint_subnet_id  = module.vpn.private_endpoint_subnet_id
  db_password                 = var.db_password
  db_user                     = var.db_user
}

module "monitoring" {
  source              = "./modules/monitoring"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  app_service_id      = module.appservice.app_service_id
  alert_email         = var.alert_email
}

module "bastion" {
  source              = "./modules/bastion"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  vnet_name           = module.vpn.vnet_name
}

module "security" {
  source                      = "./modules/security"
  resource_group_name         = azurerm_resource_group.main.name
  security_contact_email      = var.alert_email
  security_contact_phone      = var.security_contact_phone
  subscription_id             = data.azurerm_subscription.current.subscription_id
  log_analytics_workspace_id  = module.monitoring.log_analytics_workspace_id
}

module "frontdoor" {
  source               = "./modules/frontdoor"
  resource_group_name  = azurerm_resource_group.main.name
  app_service_hostname = module.appservice.hostname
}
