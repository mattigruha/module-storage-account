output "storage_account_id" {
  description = "The ID of the storage account"
  value       = azurerm_storage_account.sa.id
}

output "diagnostic_settings_id" {
  description = "The ID of the diagnostic settings"
  value       = azurerm_monitor_diagnostic_setting.la_diagnostics[*].id
}
