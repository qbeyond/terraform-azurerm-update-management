# Module
[![GitHub tag](https://img.shields.io/github/tag/qbeyond/terraform-module-template.svg)](https://registry.terraform.io/modules/qbeyond/terraform-module-template/provider/latest)
[![License](https://img.shields.io/github/license/qbeyond/terraform-module-template.svg)](https://github.com/qbeyond/terraform-module-template/blob/main/LICENSE)

----
## Description 
This Module creates an azure runbook that automatically creates and updates update deployment groups in azure automation. The created deployment groups include every virtual machine under the management group "alz" that has the severity group monthly tag with the correct syntax. The runbook runs every 12 hours starting 7am UTC+2 the next day.

## Requirements
- Powershell module az.resourcegraph in version 0.13.0 installed in the automation account
- Powershell module az.accounts in version 2.12.1 installed in automation account. Higher versions are not supported by az.resourcegraph
- System Managed Identity of the automation account with following permissions:
    - Reader on the scope of the specified management group (default alz)
    - Virtual machine contributor on the scope of the specified management group (default alz)
    - Automation contributor on the specified automation account 

<!-- BEGIN_TF_DOCS -->
## Usage

It's very easy to use!
```hcl
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
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.7.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_automation_account"></a> [automation\_account](#input\_automation\_account) | Automation account where the update management will be deployed. | <pre>object({<br/>    name                = string<br/>    id                  = string<br/>    resource_group_name = string<br/>    location            = string<br/>  })</pre> | n/a | yes |
| <a name="input_management_group_id"></a> [management\_group\_id](#input\_management\_group\_id) | ID of the management group that scopes the update management. | `string` | n/a | yes |
| <a name="input_policy_assignment_id"></a> [policy\_assignment\_id](#input\_policy\_assignment\_id) | ID of the policy assignment to remediate. | `string` | n/a | yes |
| <a name="input_policy_reference_id_linux"></a> [policy\_reference\_id\_linux](#input\_policy\_reference\_id\_linux) | ID of Policy reference for Linux. | `string` | n/a | yes |
| <a name="input_policy_reference_id_windows"></a> [policy\_reference\_id\_windows](#input\_policy\_reference\_id\_windows) | ID of Policy reference for Windows. | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Resource group used for the deployment. | <pre>object({<br/>    name     = string<br/>    location = string<br/>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to add to the resources created in this module | `map(string)` | n/a | yes |
## Outputs

No outputs.

      ## Resource types

      | Type | Used |
      |------|-------|
        | [azurerm_automation_job_schedule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_job_schedule) | 1 |
        | [azurerm_automation_runbook](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_runbook) | 1 |
        | [azurerm_automation_schedule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_schedule) | 1 |
        | [azurerm_maintenance_configuration](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/maintenance_configuration) | 1 |
        | [time_static](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | 1 |

      **`Used` only includes resource blocks.** `for_each` and `count` meta arguments, as well as resource blocks of modules are not considered.
    
## Modules

No modules.

        ## Resources by Files

            ### main.tf

            | Name | Type |
            |------|------|
                  | [azurerm_automation_job_schedule.remediate_update_management](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_job_schedule) | resource |
                  | [azurerm_automation_runbook.remediate_update_management](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_runbook) | resource |
                  | [azurerm_automation_schedule.twice_daily](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_schedule) | resource |
                  | [azurerm_maintenance_configuration.no_maintenance](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/maintenance_configuration) | resource |
                  | [time_static.start_12am_cest](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
    
<!-- END_TF_DOCS -->

# Contribute

