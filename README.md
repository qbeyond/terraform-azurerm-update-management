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
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.7.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_automation_account"></a> [automation\_account](#input\_automation\_account) | Automation account where the update management will be deployed. | <pre>object({<br>    name                = string<br>    id                  = string<br>    resource_group_name = string<br>    location            = string<br>  })</pre> | n/a | yes |
| <a name="input_az_resourcegraph_module"></a> [az\_resourcegraph\_module](#input\_az\_resourcegraph\_module) | Required module Az.resourcegraph that is needed to run queries in the runbook. | <pre>object({<br>    name = string<br>    module_link = list(object({<br>      uri = string<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_management_subscription_id"></a> [management\_subscription\_id](#input\_management\_subscription\_id) | Id of the management subscription. | `string` | n/a | yes |
| <a name="input_management_group_id"></a> [management\_group\_id](#input\_management\_group\_id) | ID of the management group that scopes the update management. | `string` | `"alz"` | no |
## Outputs

No outputs.

      ## Resource types

      | Type | Used |
      |------|-------|
        | [azurerm_automation_job_schedule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_job_schedule) | 1 |
        | [azurerm_automation_runbook](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_runbook) | 1 |
        | [azurerm_automation_schedule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_schedule) | 1 |
        | [time_static](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | 1 |

      **`Used` only includes resource blocks.** `for_each` and `count` meta arguments, as well as resource blocks of modules are not considered.
    
## Modules

No modules.

        ## Resources by Files

            ### main.tf

            | Name | Type |
            |------|------|
                  | [azurerm_automation_job_schedule.set_deployment_schedules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_job_schedule) | resource |
                  | [azurerm_automation_runbook.set_deployment_schedules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_runbook) | resource |
                  | [azurerm_automation_schedule.every_12h_starting_7am](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_schedule) | resource |
                  | [time_static.schedule_start_tomorrow_7am](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
    
<!-- END_TF_DOCS -->

# Contribute

