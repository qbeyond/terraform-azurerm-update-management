/**
 * Add a Short description of this module
 *
 * 
 */

##### Subscrition anlage

#This is due to an Azure specifica, that with 1 day of, the time generated is today.
resource "time_offset" "tomorrow" {
  offset_days = 1
}

#https://docs.microsoft.com/en-us/azure/templates/microsoft.automation/automationaccounts/softwareupdateconfigurations?tabs=json

resource "azurerm_resource_group_template_deployment" "severity_group" {
  count               = var.updateConfiguration_operatingsystem == "Windows" ? 1 : 0
  name                = var.severity_group_name
  resource_group_name = var.resource_group_name
  template_content = templatefile("${path.module}/arm_template_windows.json", {
    softwareUpdateConfigurationsName                              = "${var.automation_account_name}/${var.severity_group_name}",
    scheduleInfo_description                                      = var.scheduleInfo_description,
    scheduleInfo_frequency                                        = var.scheduleInfo_frequency,
    scheduleInfo_interval                                         = var.scheduleInfo_interval,
    scheduleInfo_isEnabled                                        = var.scheduleInfo_isEnabled,
    scheduleInfo_startTime                                        = "${local.update_date}T${var.scheduleInfo_startTime_hour}:00+00:00",
    scheduleInfo_timeZone                                         = var.scheduleInfo_timeZone,
    scheduleInfo_advancedSchedule_monthDays                       = jsonencode(var.scheduleInfo_advancedSchedule_monthDays),
    scheduleInfo_advancedSchedule_monthlyOccurrences              = var.scheduleInfo_advancedSchedule_monthlyOccurrences_day == "" || var.scheduleInfo_advancedSchedule_monthlyOccurrences_occurrence == "" ? "" : jsonencode(local.scheduleInfo_advancedSchedule_monthlyOccurrences),
    scheduleInfo_advancedSchedule_weekDays                        = jsonencode(var.scheduleInfo_advancedSchedule_weekDays),
    updateConfiguration_azureVirtualMachines                      = jsonencode(var.updateConfiguration_azureVirtualMachines),
    updateConfiguration_update_duration                           = var.updateConfiguration_update_duration,
    updateConfiguration_operatingsystem                           = var.updateConfiguration_operatingsystem,
    updateConfiguration_nonAzureComputerNames                     = jsonencode(var.updateConfiguration_nonAzureComputerNames),
    updateConfiguration_azureQueries_scope                        = jsonencode(var.updateConfiguration_azureQueries_scope),
    updateConfiguration_azureQueries_tags_severitygrouptagname    = var.updateConfiguration_azureQueries_tags_severitygrouptagname,
    updateConfiguration_azureQueries_tags_value_severitygroupname = local.updateConfiguration_azureQueries_tags_value_severitygroupname,
    updateConfiguration_nonazureQueries                           = var.updateConfiguration_nonazureQueries_workspaceId == "" || var.updateConfiguration_nonazureQueries_functionAlias == "" ? "" : jsonencode(local.updateConfiguration_nonazureQueries),
    updateConfiguration_windows_excludedKbNumbers                 = jsonencode(var.updateConfiguration_windows_excludedKbNumbers),
    updateConfiguration_windows_includedKbNumbers                 = jsonencode(var.updateConfiguration_windows_includedKbNumbers),
    updateConfiguration_windows_includedUpdateClassifications     = var.updateConfiguration_windows_includedUpdateClassifications,
    updateConfiguration_windows_rebootSetting                     = var.updateConfiguration_operatingsystem == "Windows" ? var.updateConfiguration_rebootSetting : ""
    updateConfiguration_linux_excludedPackageNameMasks            = jsonencode(var.updateConfiguration_linux_excludedPackageNameMasks),
    updateConfiguration_linux_includedPackageClassifications      = var.updateConfiguration_linux_includedPackageClassifications,
    updateConfiguration_linux_includedPackageNameMasks            = jsonencode(var.updateConfiguration_linux_excludedPackageNameMasks),
    updateConfiguration_linux_rebootSetting                       = var.updateConfiguration_operatingsystem == "Linux" ? var.updateConfiguration_rebootSetting : ""
    error_code                                                    = var.error_code,
    error_message                                                 = var.error_message
  })
  deployment_mode = "Incremental"
}

resource "azurerm_resource_group_template_deployment" "severity_group_linux" {
  count               = var.updateConfiguration_operatingsystem == "Linux" ? 1 : 0
  name                = var.severity_group_name
  resource_group_name = var.resource_group_name
  template_content = templatefile("${path.module}/arm_template_linux.json", {
    softwareUpdateConfigurationsName                              = "${var.automation_account_name}/${var.severity_group_name}",
    scheduleInfo_description                                      = var.scheduleInfo_description,
    scheduleInfo_frequency                                        = var.scheduleInfo_frequency,
    scheduleInfo_interval                                         = var.scheduleInfo_interval,
    scheduleInfo_isEnabled                                        = var.scheduleInfo_isEnabled,
    scheduleInfo_startTime                                        = "${local.update_date}T${var.scheduleInfo_startTime_hour}:00+00:00",
    scheduleInfo_timeZone                                         = var.scheduleInfo_timeZone,
    scheduleInfo_advancedSchedule_monthDays                       = jsonencode(var.scheduleInfo_advancedSchedule_monthDays),
    scheduleInfo_advancedSchedule_monthlyOccurrences              = var.scheduleInfo_advancedSchedule_monthlyOccurrences_day == "" || var.scheduleInfo_advancedSchedule_monthlyOccurrences_occurrence == "" ? "" : jsonencode(local.scheduleInfo_advancedSchedule_monthlyOccurrences),
    scheduleInfo_advancedSchedule_weekDays                        = jsonencode(var.scheduleInfo_advancedSchedule_weekDays),
    updateConfiguration_azureVirtualMachines                      = jsonencode(var.updateConfiguration_azureVirtualMachines),
    updateConfiguration_update_duration                           = var.updateConfiguration_update_duration,
    updateConfiguration_operatingsystem                           = var.updateConfiguration_operatingsystem,
    updateConfiguration_nonAzureComputerNames                     = jsonencode(var.updateConfiguration_nonAzureComputerNames),
    updateConfiguration_azureQueries_scope                        = jsonencode(var.updateConfiguration_azureQueries_scope),
    updateConfiguration_azureQueries_tags_severitygrouptagname    = var.updateConfiguration_azureQueries_tags_severitygrouptagname,
    updateConfiguration_azureQueries_tags_value_severitygroupname = local.updateConfiguration_azureQueries_tags_value_severitygroupname,
    updateConfiguration_nonazureQueries                           = var.updateConfiguration_nonazureQueries_workspaceId == "" || var.updateConfiguration_nonazureQueries_functionAlias == "" ? "" : jsonencode(local.updateConfiguration_nonazureQueries),
    updateConfiguration_windows_excludedKbNumbers                 = jsonencode(var.updateConfiguration_windows_excludedKbNumbers),
    updateConfiguration_windows_includedKbNumbers                 = jsonencode(var.updateConfiguration_windows_includedKbNumbers),
    updateConfiguration_windows_includedUpdateClassifications     = var.updateConfiguration_windows_includedUpdateClassifications,
    updateConfiguration_windows_rebootSetting                     = var.updateConfiguration_operatingsystem == "Windows" ? var.updateConfiguration_rebootSetting : ""
    updateConfiguration_linux_excludedPackageNameMasks            = jsonencode(var.updateConfiguration_linux_excludedPackageNameMasks),
    updateConfiguration_linux_includedPackageClassifications      = var.updateConfiguration_linux_includedPackageClassifications,
    updateConfiguration_linux_includedPackageNameMasks            = jsonencode(var.updateConfiguration_linux_excludedPackageNameMasks),
    updateConfiguration_linux_rebootSetting                       = var.updateConfiguration_operatingsystem == "Linux" ? var.updateConfiguration_rebootSetting : ""
    error_code                                                    = var.error_code,
    error_message                                                 = var.error_message
  })
  deployment_mode = "Incremental"
}
