locals {
  updateConfiguration_azureQueries_tags_value_severitygroupname = var.updateConfiguration_azureQueries_tags_value_severitygroupname != "" ? var.updateConfiguration_azureQueries_tags_value_severitygroupname : var.severity_group_name
  update_date                                                   = substr(time_offset.tomorrow.rfc3339, 0, 10)
  scheduleInfo_advancedSchedule_monthlyOccurrences = {
    "day" : "${var.scheduleInfo_advancedSchedule_monthlyOccurrences_day}",
    "occurrence" : "${var.scheduleInfo_advancedSchedule_monthlyOccurrences_occurrence}"
  }
  updateConfiguration_nonazureQueries = {
    "functionAlias" : "${var.updateConfiguration_nonazureQueries_functionAlias}",
    "workspaceId" : "${var.updateConfiguration_nonazureQueries_workspaceId}"
  }
}
