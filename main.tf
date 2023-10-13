resource "time_static" "tomorrow_7am" {
  rfc3339 = timeadd(formatdate("YYYY-MM-DD'T'05:00:00+02:00Z", timestamp()), "24h")
  triggers = {
    aac_name  = var.automation_account.name
    aac_id    = var.automation_account.id
    rg_name   = var.automation_account.resource_group_name
    frequency = "Day"
    interval  = 1
    timezone  = "Europe/Berlin"
    runbook   = file("${path.root}/runbooks/Set-DeploymentSchedules.ps1")
  }
}

resource "azurerm_automation_schedule" "every_12h_7am" {
  name                    = "Every 12 Hours 7AM"
  resource_group_name     = var.automation_account.resource_group_name
  automation_account_name = var.automation_account.name
  frequency               = time_static.tomorrow_7am.triggers.frequency
  interval                = time_static.tomorrow_7am.triggers.interval
  timezone                = time_static.tomorrow_7am.triggers.timezone
  start_time              = time_static.tomorrow_7am.rfc3339
  description             = "This schedule runs every twelve hours staring 7 AM."
  
  lifecycle {
    ignore_changes = [ "tags" ]
  }
}

resource "azurerm_automation_job_schedule" "set_deployment_schedules" {
  resource_group_name     = var.automation_account.resource_group_name
  automation_account_name = var.automation_account.name
  schedule_name           = azurerm_automation_schedule.every_12h_7am.name
  runbook_name            = azurerm_automation_runbook.set_deployment_schedules.name

  parameters = {
    automationaccountname       = var.automation_account.name
    automationresourcegroupname = var.automation_account.resource_group_name
    managementsubscriptionid    = var.management_subscription_id
    managementgroupid           = var.management_group_id
  }

  lifecycle {
  ignore_changes = [ "tags" ]
  }
}

resource "azurerm_automation_runbook" "set_deployment_schedules" {
  name                    = "Set-DeploymentSchedules"
  location                = var.automation_account.location
  resource_group_name     = var.automation_account.resource_group_name
  automation_account_name = var.automation_account.name
  log_verbose             = "false" #prevent https://learn.microsoft.com/en-us/azure/automation/troubleshoot/runbooks#output-stream-greater-1mb
  log_progress            = "false" #prevent https://learn.microsoft.com/en-us/azure/automation/troubleshoot/runbooks#output-stream-greater-1mb
  description             = "This Script creates and updates update management deployment groups based on tags."
  runbook_type            = "PowerShell"

  content = file("${path.root}/runbooks/Set-DeploymentSchedules.ps1")

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}


