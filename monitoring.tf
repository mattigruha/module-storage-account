# We maken een actiegroep binnen Azure Monitor
resource "azurerm_monitor_action_group" "action" {
  count = var.create_action_group ? 1 : 0 # We maken deze alleen als de variabel create_action_group "true" is

  name                = var.action_group_name       # De naam van de actiegroep
  resource_group_name = var.resource_group_name     # De naam van de resourcegroep waarin deze actiegroep zich bevindt
  short_name          = var.short_name_action_group # Een korte naam voor de actiegroep
  webhook_receiver {                                # Een webhook is een manier om apps real-time informatie te laten pushen naar andere apps
    name        = var.webhook_name                  # De naam van de webhook
    service_uri = var.service_uri                   # De URI van de service waar de webhook naartoe stuurt
  }

  tags = var.tags # Tags zijn een manier om resources te categoriseren
}

# We maken een metrische waarschuwing in Azure Monitor
resource "azurerm_monitor_metric_alert" "alert" {
  for_each = var.metric_alerts # We maken een waarschuwing voor elke metriek in metric_alerts

  name                = each.value.alert_name           # De naam van de waarschuwing
  resource_group_name = var.resource_group_name         # De naam van de resourcegroep waarin deze waarschuwing zich bevindt
  scopes              = [azurerm_storage_account.sa.id] # De scope van de waarschuwing (in dit geval een opslagaccount)
  description         = each.value.alert_description    # Een beschrijving van de waarschuwing

  tags = var.tags # Tags voor de waarschuwing

  frequency = each.value.frequency # Hoe vaak de waarschuwing wordt gecontroleerd
  severity  = each.value.severity  # De ernst van de waarschuwing

  # De criteria voor de waarschuwing
  dynamic "criteria" {
    for_each = [1] # Dit is een workaround om een enkel criteria blok te maken
    content {
      metric_namespace = "Microsoft.Storage/storageAccounts" # De namespace van de metriek
      metric_name      = each.value.metric_name              # De naam van de metriek
      aggregation      = each.value.aggregation              # De aggregatie van de metriek
      operator         = each.value.operator                 # De operator van de metriek
      threshold        = each.value.threshold                # De drempelwaarde van de metriek

      # Een enkele metrische waarschuwingsregel kan ook meerdere dimensiewaarden van een metriek monitoren
      dynamic "dimension" {
        for_each = var.metric_alerts # We maken een dimensie voor elke metriek in metric_alerts
        content {
          name     = each.value.dimension_api_name # De naam van de API van de dimensie
          operator = each.value.dimension_operator # De operator van de dimensie
          values   = each.value.dimension_values   # De waarden van de dimensie
        }
      }
    }
  }
  action {
    action_group_id = var.create_action_group ? azurerm_monitor_action_group.action[0].id : null # De ID van de actiegroep die wordt geactiveerd
  }                                                                                              # als de waarschuwing afgaat.
}

# We maken een Log Analytics workspace voor het opslagaccount (optioneel)
resource "azurerm_log_analytics_workspace" "la_log" {
  count                           = var.create_log_analytics_workspace ? 1 : 0 # We maken deze alleen als variabel create_log_analytics_workspace "true" is
  name                            = "la-${var.workspace_name}-monitoring"      # De naam van de workspace
  location                        = var.location                               # De locatie van de workspace
  resource_group_name             = var.resource_group_name                    # De naam van de resourcegroep waarin deze workspace zich bevindt
  tags                            = var.tags                                   # Tags voor de workspace
  allow_resource_only_permissions = true                                       # Alleen resources mogen toestemmingen hebben
  local_authentication_disabled   = true                                       # Lokale authenticatie is uitgeschakeld
  sku                             = "PerGB2018"                                # Het SKU van de workspace
  retention_in_days               = 30                                         # Hoe lang de data wordt bewaard
  internet_ingestion_enabled      = true                                       # Internetinname is ingeschakeld
  internet_query_enabled          = true                                       # Internetquery is ingeschakeld
}

# We schakelen diagnostiek in op het opslagaccount om activiteitenlogs naar de Log Analytics workspace te sturen
resource "azurerm_monitor_diagnostic_setting" "la_diagnostics" {
  count              = var.create_log_analytics_workspace ? 1 : 0               # We maken deze alleen als variabel create_log_analytics_workspace "true" is
  name               = azurerm_log_analytics_workspace.la_log[count.index].name # De naam van de diagnostische instelling
  target_resource_id = azurerm_storage_account.sa.id                            # Het ID van de resource waarop de diagnostiek wordt toegepast
}
