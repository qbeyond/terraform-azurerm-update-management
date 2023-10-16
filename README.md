# Module
[![GitHub tag](https://img.shields.io/github/tag/qbeyond/terraform-module-template.svg)](https://registry.terraform.io/modules/qbeyond/terraform-module-template/provider/latest)
[![License](https://img.shields.io/github/license/qbeyond/terraform-module-template.svg)](https://github.com/qbeyond/terraform-module-template/blob/main/LICENSE)

----
<!-- BEGIN_TF_DOCS -->
This Module creates an azure runbook that automatically creates and updates update deployment groups in azure automation. The created deployment groups include every virtual machine under the management group "alz" that has the severity group monthly tag with the correct syntax. The runbook runs every 12 hours starting 7am UTC+2 the next day.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.7.0 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group_template_deployment.severity_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) | resource |
| [azurerm_resource_group_template_deployment.severity_group_linux](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) | resource |
| [time_offset.tomorrow](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/offset) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_automation_account_name"></a> [automation\_account\_name](#input\_automation\_account\_name) | The name of the automation account. | `string` | n/a | yes |
| <a name="input_error_code"></a> [error\_code](#input\_error\_code) | Custom Error code | `string` | `""` | no |
| <a name="input_error_message"></a> [error\_message](#input\_error\_message) | Error message indicating why the operation failed. | `string` | `""` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group of automation account, where update management is enabled | `string` | n/a | yes |
| <a name="input_scheduleInfo_advancedSchedule_monthDays"></a> [scheduleInfo\_advancedSchedule\_monthDays](#input\_scheduleInfo\_advancedSchedule\_monthDays) | (Optional) A list of every day in a month to run the severity group, available 1-31 | `list(string)` | `[]` | no |
| <a name="input_scheduleInfo_advancedSchedule_monthlyOccurrences_day"></a> [scheduleInfo\_advancedSchedule\_monthlyOccurrences\_day](#input\_scheduleInfo\_advancedSchedule\_monthlyOccurrences\_day) | (Optional) Day of the occurrence. Must be one of monday, tuesday, wednesday, thursday, friday, saturday, sunday. | `string` | `""` | no |
| <a name="input_scheduleInfo_advancedSchedule_monthlyOccurrences_occurrence"></a> [scheduleInfo\_advancedSchedule\_monthlyOccurrences\_occurrence](#input\_scheduleInfo\_advancedSchedule\_monthlyOccurrences\_occurrence) | (Optional) Occurrence of the week within the month. Must be between 1 and 5. | `number` | `0` | no |
| <a name="input_scheduleInfo_advancedSchedule_weekDays"></a> [scheduleInfo\_advancedSchedule\_weekDays](#input\_scheduleInfo\_advancedSchedule\_weekDays) | (Optional) Days of the week that the job should execute on. | `list(string)` | `[]` | no |
| <a name="input_scheduleInfo_description"></a> [scheduleInfo\_description](#input\_scheduleInfo\_description) | A description for the Severity Group | `string` | `""` | no |
| <a name="input_scheduleInfo_frequency"></a> [scheduleInfo\_frequency](#input\_scheduleInfo\_frequency) | Day,Hour,Minute,Month,OneTime,Week | `string` | n/a | yes |
| <a name="input_scheduleInfo_interval"></a> [scheduleInfo\_interval](#input\_scheduleInfo\_interval) | Set the interval of the schedule | `number` | n/a | yes |
| <a name="input_scheduleInfo_isEnabled"></a> [scheduleInfo\_isEnabled](#input\_scheduleInfo\_isEnabled) | Enable the Severity Group? | `bool` | `true` | no |
| <a name="input_scheduleInfo_startTime_hour"></a> [scheduleInfo\_startTime\_hour](#input\_scheduleInfo\_startTime\_hour) | Set the hour when to start, in format 05:00 | `string` | n/a | yes |
| <a name="input_scheduleInfo_timeZone"></a> [scheduleInfo\_timeZone](#input\_scheduleInfo\_timeZone) | Set the time zone | `string` | `"Europe/Berlin"` | no |
| <a name="input_severity_group_name"></a> [severity\_group\_name](#input\_severity\_group\_name) | The name of the Severity Group to create | `string` | n/a | yes |
| <a name="input_tasks_postTask_parameters"></a> [tasks\_postTask\_parameters](#input\_tasks\_postTask\_parameters) | (Optional) Days of the week that the job should execute on. | `string` | `""` | no |
| <a name="input_tasks_postTask_source"></a> [tasks\_postTask\_source](#input\_tasks\_postTask\_source) | (Optional) Sets the name of the runbook. | `string` | `""` | no |
| <a name="input_tasks_preTask_parameters"></a> [tasks\_preTask\_parameters](#input\_tasks\_preTask\_parameters) | (Optional) Days of the week that the job should execute on. | `string` | `""` | no |
| <a name="input_tasks_preTask_source"></a> [tasks\_preTask\_source](#input\_tasks\_preTask\_source) | (Optional) Sets the name of the runbook. | `string` | `""` | no |
| <a name="input_updateConfiguration_azureQueries_scope"></a> [updateConfiguration\_azureQueries\_scope](#input\_updateConfiguration\_azureQueries\_scope) | (Optional) List of names of non-azure machines targeted by the software update configuration. | `list(string)` | `[]` | no |
| <a name="input_updateConfiguration_azureQueries_tags_severitygrouptagname"></a> [updateConfiguration\_azureQueries\_tags\_severitygrouptagname](#input\_updateConfiguration\_azureQueries\_tags\_severitygrouptagname) | The name of the TAG this Severity Group will apply to. Its most likely Severity Group Daily or Secerity Group Monthly | `string` | n/a | yes |
| <a name="input_updateConfiguration_azureQueries_tags_value_severitygroupname"></a> [updateConfiguration\_azureQueries\_tags\_value\_severitygroupname](#input\_updateConfiguration\_azureQueries\_tags\_value\_severitygroupname) | If the Severity Group Name does not equals the severity group Tag value, you can set a customized value here, otherwise leave it blank. | `string` | `""` | no |
| <a name="input_updateConfiguration_azureVirtualMachines"></a> [updateConfiguration\_azureVirtualMachines](#input\_updateConfiguration\_azureVirtualMachines) | (Optional) List of azure resource Ids for azure virtual machines targeted by the software update configuration. | `list(string)` | `[]` | no |
| <a name="input_updateConfiguration_linux_excludedPackageNameMasks"></a> [updateConfiguration\_linux\_excludedPackageNameMasks](#input\_updateConfiguration\_linux\_excludedPackageNameMasks) | (Optional) packages excluded from the software update configuration. | `list(string)` | `[]` | no |
| <a name="input_updateConfiguration_linux_includedPackageClassifications"></a> [updateConfiguration\_linux\_includedPackageClassifications](#input\_updateConfiguration\_linux\_includedPackageClassifications) | Update classifications included in the software update configuration. Critical,Other,Security,Unclassified | `string` | `""` | no |
| <a name="input_updateConfiguration_linux_includedPackageNameMasks"></a> [updateConfiguration\_linux\_includedPackageNameMasks](#input\_updateConfiguration\_linux\_includedPackageNameMasks) | (Optional) packages included from the software update configuration. | `list(string)` | `[]` | no |
| <a name="input_updateConfiguration_nonAzureComputerNames"></a> [updateConfiguration\_nonAzureComputerNames](#input\_updateConfiguration\_nonAzureComputerNames) | (Optional) List of names of non-azure machines targeted by the software update configuration. | `list(string)` | `[]` | no |
| <a name="input_updateConfiguration_nonazureQueries_functionAlias"></a> [updateConfiguration\_nonazureQueries\_functionAlias](#input\_updateConfiguration\_nonazureQueries\_functionAlias) | Log Analytics Saved Search name. | `string` | `""` | no |
| <a name="input_updateConfiguration_nonazureQueries_workspaceId"></a> [updateConfiguration\_nonazureQueries\_workspaceId](#input\_updateConfiguration\_nonazureQueries\_workspaceId) | Workspace Id for Log Analytics in which the saved Search is resided. | `string` | `""` | no |
| <a name="input_updateConfiguration_operatingsystem"></a> [updateConfiguration\_operatingsystem](#input\_updateConfiguration\_operatingsystem) | Target operating system for the software update configuration.	Linux or Windows | `string` | n/a | yes |
| <a name="input_updateConfiguration_rebootSetting"></a> [updateConfiguration\_rebootSetting](#input\_updateConfiguration\_rebootSetting) | Reboot setting for the software update configuration. Values are IfRequired, Never, Always, RebootOnly | `string` | `""` | no |
| <a name="input_updateConfiguration_update_duration"></a> [updateConfiguration\_update\_duration](#input\_updateConfiguration\_update\_duration) | Maximum time allowed for the software update configuration run. Define the Hours of duration as string. | `string` | `"4"` | no |
| <a name="input_updateConfiguration_windows_excludedKbNumbers"></a> [updateConfiguration\_windows\_excludedKbNumbers](#input\_updateConfiguration\_windows\_excludedKbNumbers) | (Optional) KB numbers excluded from the software update configuration. | `list(string)` | `[]` | no |
| <a name="input_updateConfiguration_windows_includedKbNumbers"></a> [updateConfiguration\_windows\_includedKbNumbers](#input\_updateConfiguration\_windows\_includedKbNumbers) | (Optional) KB numbers included from the software update configuration. | `list(string)` | `[]` | no |
| <a name="input_updateConfiguration_windows_includedUpdateClassifications"></a> [updateConfiguration\_windows\_includedUpdateClassifications](#input\_updateConfiguration\_windows\_includedUpdateClassifications) | Update classification included in the software update configuration. A comma separated string with required values. Critical,Definition,FeaturePack,Security,ServicePack,Tools,Unclassified,UpdateRollup,Updates | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

# Contribute

