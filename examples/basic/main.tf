provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
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
locals {
  management_group_id    = "alz"
  policy_assignment_name = "QBY-Deploy-Update-Mgmt"
}

module "update_management" {
  source                      = "../.."
  resource_group              = azurerm_resource_group.example
  automation_account          = azurerm_automation_account.example
  management_group_id         = local.management_group_id
  policy_assignment_id        = "/providers/microsoft.management/managementgroups/${local.management_group_id}/providers/microsoft.authorization/policyassignments/${local.policy_assignment_name}"
  tags                        = {}
  policy_reference_id_linux   = "Configure update management for Linux virtual machines with a given tag using Azure Update Manager"
  policy_reference_id_windows = "Configure update management for Windows virtual machines with a given tag using Azure Update Manager"
}
