resource "azurerm_container_app_environment" "demo-cae" {
  location = azurerm_resource_group.demo-rg.location
  name = "demo-cae-${var.env_id}"
  resource_group_name = azurerm_resource_group.demo-rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.demo-law.id

  tags = {
    environment = var.env_id
    source      = var.source_key
  }  
}