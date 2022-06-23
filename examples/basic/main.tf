module "severity-severity-01-third-sunday-2200-reboot" {
  source                                                      = "qbeyond/update-management/azurerm"
  version                                                     = "1.0.0"
  resource_group_name                                         = local.resource_group_name_automation_account
  automation_account_name                                     = local.automation_account_name
  severity_group_name                                         = "01-third-sunday-2200-reboot"
  scheduleInfo_frequency                                      = "Month"
  scheduleInfo_interval                                       = "1"
  scheduleInfo_startTime_hour                                 = "22:00"
  updateConfiguration_operatingsystem                         = "Windows"
  updateConfiguration_azureQueries_tags_severitygrouptagname  = "Severity Group Monthly"
  updateConfiguration_azureQueries_scope                      = data.azurerm_subscriptions.available.subscriptions.*.id
  updateConfiguration_windows_includedUpdateClassifications   = "Critical, Security, UpdateRollup, FeaturePack, ServicePack, Definition, Tools, Updates"
  updateConfiguration_rebootSetting                           = "IfRequired"
  scheduleInfo_advancedSchedule_monthlyOccurrences_day        = "Sunday"
  scheduleInfo_advancedSchedule_monthlyOccurrences_occurrence = 3
}
