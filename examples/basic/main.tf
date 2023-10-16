provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_automation_account" "example" {
  name                = "example-account"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku_name            = "Basic"
}

module "update_management" {
  source                                                      = "../.."
  automation_account = azurerm_automation_account.example
  management_subscription_id = "abcdef01-2345-6789-0abc-def012345678"
}
