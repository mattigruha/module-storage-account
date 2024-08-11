# Module to create a Storage Account, Container and (optional) metric alert for the Storage Account.

## Requirements

| Name | Version |
|------|---------|
| [terraform](#requirement\_terraform) | >= 1.0.0 |
| [azurerm](#requirement\_azurerm) | >= 3.0.0, < 4.0.0 |
| [random](#requirement\_random) | 3.5.1 |

## Providers

| Name | Version |
|------|---------|
| [azurerm](#provider\_azurerm) | 3.82.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_log_analytics_workspace.la_log](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_monitor_action_group.action](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_diagnostic_setting.la_diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_metric_alert.alert](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_storage_account.sa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_container.azurerm_storage_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| [access\_tier](#input\_access\_tier) | Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool. Defaults to Hot. | `string` | `"Hot"` | no |
| [account\_kind](#input\_account\_kind) | Defines the kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2 | `string` | `null` | no |
| [account\_replication\_type](#input\_account\_replication\_type) | Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS | `string` | `null` | no |
| [account\_tier](#input\_account\_tier) | Defines the Tier to use for this storage account. Valid options are Standard and Premium | `string` | `null` | no |
| [action\_group\_name](#input\_action\_group\_name) | Name of the action group | `string` | `null` | no |
| [allow\_nested\_items\_to\_be\_public](#input\_allow\_nested\_items\_to\_be\_public) | Allow or disallow nested items within this Account to opt into being public. Defaults to false. | `bool` | `false` | no |
| [container\_access\_type](#input\_container\_access\_type) | Specifies the access level for the container. Possible values are blob, container or private | `string` | `"private"` | no |
| [container\_name](#input\_container\_name) | Name of the container | `string` | n/a | yes |
| [create\_action\_group](#input\_create\_action\_group) | Boolean flag to create an action group. Possible values are true or false | `bool` | `false` | no |
| [create\_log\_analytics\_workspace](#input\_create\_log\_analytics\_workspace) | Boolean variable to create a log analytics workspace. Possible values are true or false. Default is false. | `bool` | `false` | no |
| [cross\_tenant\_replication\_enabled](#input\_cross\_tenant\_replication\_enabled) | Should cross Tenant replication be enabled. Possible values are true or false | `bool` | `false` | no |
| [edge\_zone](#input\_edge\_zone) | Specifies the Edge Zone within the Azure Region where this Storage Account should exist | `string` | `null` | no |
| [enable\_https\_traffic\_only](#input\_enable\_https\_traffic\_only) | Boolean flag which forces HTTPS if enabled. Optional values are true or false. | `bool` | `true` | no |
| [location](#input\_location) | The location where the resource group is located | `string` | `"West Europe"` | no |
| [metadata](#input\_metadata) | (Optional) A mapping of MetaData for this Container. All metadata keys should be lowercase. | `map(string)` | `{}` | no |
| [metric\_alerts](#input\_metric\_alerts) | Map of metric alerts | ```map(object({ alert_name = string alert_description = string metric_name = string aggregation = string operator = string threshold = number frequency = string severity = number dimension_api_name = string dimension_operator = string dimension_values = list(string) }))``` | `{}` | no |
| [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| [service\_uri](#input\_service\_uri) | The service uri of the webhook | `string` | `null` | no |
| [shared\_access\_key\_enabled](#input\_shared\_access\_key\_enabled) | Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. Optional values are true or false. | `bool` | `false` | no |
| [short\_name\_action\_group](#input\_short\_name\_action\_group) | Short name of the action group | `string` | `null` | no |
| [storage\_account\_name](#input\_storage\_account\_name) | Name of the storage account | `string` | n/a | yes |
| [tags](#input\_tags) | Tags used for the resources | `map(string)` | n/a | yes |
| [webhook\_name](#input\_webhook\_name) | Name of the webhook | `string` | `null` | no |
| [workspace\_name](#input\_workspace\_name) | The name of the log analytics workspace to attach the metric alert to. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| [diagnostic\_settings\_id](#output\_diagnostic\_settings\_id) | The ID of the diagnostic settings |
| [storage\_account\_id](#output\_storage\_account\_id) | The ID of the storage account |

# Beforehand you'll need to create a new Resource Group or use an existing one
```hcl
resource "azurerm_resource_group" "rg" {
  name     = "test-sa-rg"
  location = "westeurope"

  tags = {
    Project     = ""
    Application = ""
    Environment = ""
    CreatedBy   = ""
    CreatedFor  = ""
  }
}

## Usage
```hcl
module "storage_account" {
  source = "../.."

  resource_group_name              = azurerm_resource_group.rg.name
  storage_account_name             = "sa${var.environment}name"
  account_kind                     = "BlobStorage"
  account_tier                     = "Standard"
  account_replication_type         = "LRS"
  cross_tenant_replication_enabled = false
  access_tier                      = "Hot"
  enable_https_traffic_only        = true
  allow_nested_items_to_be_public  = false
  shared_access_key_enabled        = true
  container_name                   = "test-container"

  tags = {
    Project     = ""
    Application = ""
    Environment = ""
    CreatedBy   = ""
    CreatedFor  = ""
  }

  ## Creating the metric alert for the storage account (optional)
  create_action_group     = true # Defaults to false. Set to true if you want to create an action group with metric alerts for the storage account.
  action_group_name       = "test-action-group"
  short_name_action_group = "test-action"
  webhook_name            = "test-webhook"
  service_uri             = "https://www.digitalsurvivalcompany.com"

  ## Provide input values for the for_each loop regarding the metric alert for the storage account
  metric_alerts = {
    "alert1" = {
      alert_name        = "Alert 1"
      alert_description = "This is alert 1"
      metric_name       = "Transactions"
      aggregation       = "Total"
      operator          = "GreaterThan"
      threshold         = 5
      frequency         = "PT1M"
      severity          = 3

      dimension_api_name = "ApiName"
      dimension_operator = "Include"
      dimension_values   = ["*"]
    }
  }

  ## Create a log analytics workspace for the storage account (optional).
  create_log_analytics_workspace = true # Defaults to false. Set to true if you want to create a log analytics workspace and enable diagnostic settings for the storage account.
  workspace_name                 = "test-log-analytics-workspace"
}
