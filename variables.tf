variable "resource_group_name" {
  description = "The resource group of automation account, where update management is enabled"
  type        = string
}

variable "automation_account_name" {
  description = "The name of the automation account."
  type        = string
}

variable "severity_group_name" {
  description = "The name of the Severity Group to create"
  type        = string
}

variable "scheduleInfo_frequency" {
  description = "Day,Hour,Minute,Month,OneTime,Week"
  type        = string
}

variable "scheduleInfo_interval" {
  description = "Set the interval of the schedule"
  type        = number
}

variable "scheduleInfo_startTime_hour" {
  description = "Set the hour when to start, in format 05:00"
  type        = string
}

variable "updateConfiguration_operatingsystem" {
  description = "Target operating system for the software update configuration.	Linux or Windows"
  type        = string
}

variable "updateConfiguration_azureQueries_tags_severitygrouptagname" {
  description = "The name of the TAG this Severity Group will apply to. Its most likely Severity Group Daily or Secerity Group Monthly"
  type        = string
}

########  Defaults ###########

variable "scheduleInfo_description" {
  description = "A description for the Severity Group"
  type        = string
  default     = ""
}

variable "scheduleInfo_isEnabled" {
  description = "Enable the Severity Group?"
  type        = bool
  default     = true
}

variable "scheduleInfo_timeZone" {
  description = "Set the time zone"
  type        = string
  default     = "Europe/Berlin"
}

variable "updateConfiguration_update_duration" {
  description = "Maximum time allowed for the software update configuration run. Define the Hours of duration as string."
  type        = string
  default     = "4"
}

########  Zero Defaults ###########

variable "scheduleInfo_advancedSchedule_monthDays" {
  description = "(Optional) A list of every day in a month to run the severity group, available 1-31"
  type        = list(string)
  default     = []
}

variable "scheduleInfo_advancedSchedule_monthlyOccurrences_day" {
  description = "(Optional) Day of the occurrence. Must be one of monday, tuesday, wednesday, thursday, friday, saturday, sunday."
  type        = string
  default     = ""
}

variable "scheduleInfo_advancedSchedule_monthlyOccurrences_occurrence" {
  description = "(Optional) Occurrence of the week within the month. Must be between 1 and 5."
  type        = number
  default     = 0
}

variable "scheduleInfo_advancedSchedule_weekDays" {
  description = "(Optional) Days of the week that the job should execute on."
  type        = list(string)
  default     = []
}

variable "tasks_preTask_parameters" {
  description = "(Optional) Days of the week that the job should execute on."
  type        = string
  default     = ""
}

variable "tasks_preTask_source" {
  description = "(Optional) Sets the name of the runbook."
  type        = string
  default     = ""
}

variable "tasks_postTask_parameters" {
  description = "(Optional) Days of the week that the job should execute on."
  type        = string
  default     = ""
}

variable "tasks_postTask_source" {
  description = "(Optional) Sets the name of the runbook."
  type        = string
  default     = ""
}

variable "updateConfiguration_azureVirtualMachines" {
  description = "(Optional) List of azure resource Ids for azure virtual machines targeted by the software update configuration."
  type        = list(string)
  default     = []
}

variable "updateConfiguration_nonAzureComputerNames" {
  description = "(Optional) List of names of non-azure machines targeted by the software update configuration."
  type        = list(string)
  default     = []
}

variable "updateConfiguration_azureQueries_scope" {
  description = "(Optional) List of names of non-azure machines targeted by the software update configuration."
  type        = list(string)
  default     = []
}

variable "updateConfiguration_azureQueries_tags_value_severitygroupname" {
  description = "If the Severity Group Name does not equals the severity group Tag value, you can set a customized value here, otherwise leave it blank."
  type        = string
  default     = ""
}

variable "updateConfiguration_nonazureQueries_functionAlias" {
  description = "Log Analytics Saved Search name."
  type        = string
  default     = ""
}

variable "updateConfiguration_nonazureQueries_workspaceId" {
  description = "Workspace Id for Log Analytics in which the saved Search is resided."
  type        = string
  default     = ""
}

variable "updateConfiguration_windows_includedUpdateClassifications" {
  description = "Update classification included in the software update configuration. A comma separated string with required values. Critical,Definition,FeaturePack,Security,ServicePack,Tools,Unclassified,UpdateRollup,Updates"
  type        = string
  default     = ""
}

variable "updateConfiguration_windows_excludedKbNumbers" {
  description = "(Optional) KB numbers excluded from the software update configuration."
  type        = list(string)
  default     = []
}

variable "updateConfiguration_windows_includedKbNumbers" {
  description = "(Optional) KB numbers included from the software update configuration."
  type        = list(string)
  default     = []
}

variable "updateConfiguration_linux_excludedPackageNameMasks" {
  description = "(Optional) packages excluded from the software update configuration."
  type        = list(string)
  default     = []
}

variable "updateConfiguration_linux_includedPackageClassifications" {
  description = "Update classifications included in the software update configuration. Critical,Other,Security,Unclassified"
  type        = string
  default     = ""
}

variable "updateConfiguration_linux_includedPackageNameMasks" {
  description = "(Optional) packages included from the software update configuration."
  type        = list(string)
  default     = []
}

variable "updateConfiguration_rebootSetting" {
  description = "Reboot setting for the software update configuration. Values are IfRequired, Never, Always, RebootOnly"
  type        = string
  default     = ""
}

variable "error_code" {
  description = "Custom Error code"
  type        = string
  default     = ""
}

variable "error_message" {
  description = "Error message indicating why the operation failed."
  type        = string
  default     = ""
}
