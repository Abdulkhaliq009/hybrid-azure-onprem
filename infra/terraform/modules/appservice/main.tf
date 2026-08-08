resource "azurerm_service_plan" "main" {
  name                = "asp-hybrid-lab"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "main" {
  name                = "app-hybrid-lab-${random_string.suffix.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    application_stack {
      node_version = "20-lts"
    }
  }

  app_settings = {
    DB_HOST     = var.db_host
    DB_NAME     = var.db_name
    DB_USER     = var.db_user
    DB_PASSWORD = var.db_password
    DB_PORT     = "1433"
  }

  virtual_network_subnet_id = var.subnet_id
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}
