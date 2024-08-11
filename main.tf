resource "azurerm_storage_account" "sa" {
  name                = lower(var.storage_account_name)
  resource_group_name = var.resource_group_name
  location            = var.location

  account_kind                     = var.account_kind
  account_tier                     = var.account_tier
  account_replication_type         = var.account_replication_type
  cross_tenant_replication_enabled = var.cross_tenant_replication_enabled
  access_tier                      = var.access_tier
  edge_zone                        = var.edge_zone
  enable_https_traffic_only        = var.enable_https_traffic_only
  min_tls_version                  = "TLS1_2"
  allow_nested_items_to_be_public  = var.allow_nested_items_to_be_public
  shared_access_key_enabled        = var.shared_access_key_enabled

  tags = var.tags
}

resource "azurerm_storage_container" "azurerm_storage_container" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = var.container_access_type
  metadata              = var.metadata
}
