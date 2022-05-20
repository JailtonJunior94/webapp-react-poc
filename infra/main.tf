terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-rg"
    storage_account_name = "storageterraformjj"
    container_name       = "poc-webapp-linux-infra"
    key                  = "terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.71.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "poc_webapp_linux_rg" {
  name     = "poc-webapp-linux-rg"
  location = var.location
}

resource "azurerm_app_service_plan" "poc_linux_sp" {
  name                = "poc-sp"
  resource_group_name = azurerm_resource_group.poc_webapp_linux_rg.name
  location            = azurerm_resource_group.poc_webapp_linux_rg.location

  sku {
    tier = "Standard"
    size = "S1"
  }

  depends_on = [
    azurerm_resource_group.poc_webapp_linux_rg
  ]
}

resource "azurerm_app_service" "poc_myapp_wa" {
  name                = "myapp"
  resource_group_name = azurerm_resource_group.poc_webapp_linux_rg.name
  location            = azurerm_resource_group.poc_webapp_linux_rg.location
  app_service_plan_id = azurerm_app_service_plan.poc_linux_sp.id

  site_config {
    always_on        = true
    linux_fx_version = "DOCKER|jailtonjunior/web:latest"
  }

  app_settings = {
    DOCKER_REGISTRY_SERVER_URL = "https:docker.io"
    API_URL                    = "via_terraform"
  }

  depends_on = [
    azurerm_service_plan.poc_linux_sp
  ]
}