resource "time_static" "start_12am_cest" {
  # The start_time of schedule needs to be in the future
  # Use time static to avoid recreating schedule on any invocation
  rfc3339 = timeadd(formatdate("YYYY-MM-DD'T'22:00:00Z", timestamp()), "24h")
  triggers = {
    aac_name  = var.automation_account.name
    aac_id    = var.automation_account.id
    rg_name   = var.resource_group.name
    frequency = "Hour"
    interval  = 12
    timezone  = "Europe/Berlin"
    runbook   = file("${path.module}/runbooks/Remediate-UpdateManagement.ps1")
  }
}

resource "azurerm_automation_runbook" "remediate_update_management" {
  name                    = "Remediate-UpdateManagement"
  location                = var.resource_group.location
  resource_group_name     = var.resource_group.name
  automation_account_name = var.automation_account.name
  log_verbose             = "true"
  log_progress            = "true"
  description             = "This runbook starts update management policy remediations based on policy assignments and references."
  runbook_type            = "PowerShell"
  content                 = file("${path.module}/runbooks/Remediate-UpdateManagement.ps1")
  tags                    = var.tags
}

resource "azurerm_automation_schedule" "twice_daily" {
  name                    = "aas-Remediate-UpdateManagement-Twice-Daily"
  resource_group_name     = var.resource_group.name
  automation_account_name = var.automation_account.name
  frequency               = time_static.start_12am_cest.triggers.frequency
  interval                = time_static.start_12am_cest.triggers.interval
  timezone                = time_static.start_12am_cest.triggers.timezone
  start_time              = time_static.start_12am_cest.rfc3339
}

resource "azurerm_automation_job_schedule" "remediate_update_management" {
  resource_group_name     = var.resource_group.name
  automation_account_name = var.automation_account.name
  schedule_name           = azurerm_automation_schedule.twice_daily.name
  runbook_name            = azurerm_automation_runbook.remediate_update_management.name

  parameters = {
    managementgroupid        = var.management_group_id
    policyassignmentid       = var.policy_assignment_id
    policyreferenceidlinux   = var.policy_reference_id_linux
    policyreferenceidwindows = var.policy_reference_id_windows
  }

  lifecycle {
    replace_triggered_by = [azurerm_automation_runbook.remediate_update_management]
  }
}

resource "azurerm_maintenance_configuration" "no_maintenance" {
  name                     = "NoMaintenance"
  resource_group_name      = var.resource_group.name
  location                 = var.resource_group.location
  scope                    = "InGuestPatch"
  in_guest_user_patch_mode = "User"

  window {
    start_date_time      = formatdate("YYYY-MM-DD hh:mm", timestamp())
    expiration_date_time = formatdate("YYYY-MM-DD hh:mm", timeadd(timestamp(), "150m"))
    duration             = "02:00"
    time_zone            = "W. Europe Standard Time"
    recur_every          = "Day"
  }

  install_patches {
    linux {
      classifications_to_include = ["Other"]
    }
    reboot = "Never"
  }
  tags = var.tags

  lifecycle {
    ignore_changes = [
      install_patches[0].reboot,
      window[0].start_date_time,
      window[0].expiration_date_time
    ]
  }
}
