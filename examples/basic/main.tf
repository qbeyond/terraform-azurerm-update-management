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

resource "azurerm_automation_module" "az_accounts" {
  name                    = "Az.Accounts"
  resource_group_name     = azurerm_resource_group.example.name
  automation_account_name = azurerm_automation_account.example.name

  module_link {
    uri = "https://devopsgallerystorage.blob.core.windows.net:443/packages/az.accounts.2.12.1.nupkg"
  }
}

resource "azurerm_automation_module" "az_resourcegraph" {
  name                    = "Az.Resourcegraph"
  resource_group_name     = azurerm_resource_group.example.name
  automation_account_name = azurerm_automation_account.example.name
  module_link {
    uri = "https://devopsgallerystorage.blob.core.windows.net:443/packages/az.resourcegraph.0.13.0.nupkg"
  }
  depends_on = [azurerm_automation_module.az_accounts]
}

module "update_management" {
  source                     = "../.."
  automation_account         = azurerm_automation_account.example
  management_subscription_id = "abcdef01-2345-6789-0abc-def012345678"
  management_group_id        = "sandbox"
  az_resourcegraph_module    = azurerm_automation_module.az_resourcegraph
}
