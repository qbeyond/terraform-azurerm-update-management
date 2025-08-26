variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Resource group used for the deployment."
}

variable "automation_account" {
  type = object({
    name                = string
    id                  = string
    resource_group_name = string
    location            = string
  })
  description = "Automation account where the update management will be deployed."
  nullable    = false
}

variable "management_group_id" {
  type        = string
  description = "ID of the management group that scopes the update management."
}

variable "policy_assignment_id" {
  type        = string
  description = "ID of the policy assignment to remediate."
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to add to the resources created in this module"
}

variable "policy_reference_id_linux" {
  type        = string
  description = "ID of Policy reference for Linux."
}

variable "policy_reference_id_windows" {
  type        = string
  description = "ID of Policy reference for Windows."
}
