# Required input variables
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "workspace_name" {
  description = "The name of the log analytics workspace to attach the metric alert to."
  type        = string
  default     = null
}

variable "create_log_analytics_workspace" {
  description = "Boolean variable to create a log analytics workspace. Possible values are true or false. Default is false."
  type        = bool
  default     = false
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
}

variable "location" {
  description = "The location where the resource group is located"
  default     = "West Europe"
  type        = string
}

variable "tags" {
  description = "Tags used for the resources"
  type        = map(string)
}

# Optional variables for the Storage Account configuration
variable "account_kind" {
  description = "Defines the kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2"
  type        = string
  default     = null
}

variable "account_tier" {
  description = "Defines the Tier to use for this storage account. Valid options are Standard and Premium"
  type        = string
  default     = null
}

variable "account_replication_type" {
  description = "Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS"
  type        = string
  default     = null
}

variable "cross_tenant_replication_enabled" {
  description = "Should cross Tenant replication be enabled. Possible values are true or false"
  type        = bool
  default     = false
}

variable "access_tier" {
  description = "Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool. Defaults to Hot."
  type        = string
  default     = "Hot"
}

variable "edge_zone" {
  description = "Specifies the Edge Zone within the Azure Region where this Storage Account should exist"
  type        = string
  default     = null
}

variable "enable_https_traffic_only" {
  description = "Boolean flag which forces HTTPS if enabled. Optional values are true or false."
  type        = bool
  default     = true
}

variable "allow_nested_items_to_be_public" {
  description = "Allow or disallow nested items within this Account to opt into being public. Defaults to false."
  type        = bool
  default     = false
}

variable "shared_access_key_enabled" {
  description = "Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. Optional values are true or false."
  type        = bool
  default     = false
}

variable "container_name" {
  description = "Name of the container"
  type        = string
}

variable "container_access_type" {
  description = "Specifies the access level for the container. Possible values are blob, container or private"
  type        = string
  default     = "private"
}

variable "metadata" {
  description = "(Optional) A mapping of MetaData for this Container. All metadata keys should be lowercase."
  type        = map(string)
  default     = {}
}

# For_each loop variables for creating a metric alert for the Storage Account
variable "metric_alerts" {
  description = "Map of metric alerts"
  type = map(object({
    alert_name        = string
    alert_description = string
    metric_name       = string
    aggregation       = string
    operator          = string
    threshold         = number

    frequency = string
    severity  = number

    dimension_api_name = string
    dimension_operator = string
    dimension_values   = list(string)
  }))
  default = {}
}

# Metric Alert input variables for the Storage Account (optional)
variable "create_action_group" {
  description = "Boolean flag to create an action group. Possible values are true or false"
  type        = bool
  default     = false
}

variable "action_group_name" {
  description = "Name of the action group"
  type        = string
  default     = null
}

variable "short_name_action_group" {
  description = "Short name of the action group"
  type        = string
  default     = null
}

variable "webhook_name" {
  description = "Name of the webhook"
  type        = string
  default     = null
}

variable "service_uri" {
  description = "The service uri of the webhook"
  type        = string
  default     = null
}
