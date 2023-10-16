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

variable "az_resourcegraph_module" {
  type = object({
    name = string
    module_link = list(object({
      uri = string
    }))
  })
  description = "Required module Az.resourcegraph that is needed to run queries in the runbook."
  validation {
    condition =  endswith(var.az_resourcegraph_module.module_link[0].uri, "az.resourcegraph.0.13.0.nupkg")
    error_message = "az.resourcegraph in version 0.13.0 is required"
  }
}
