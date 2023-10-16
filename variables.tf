variable "management_subscription_id" {
  type        = string
  description = "Id of the management subscription."
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
  default     = "alz"
}
