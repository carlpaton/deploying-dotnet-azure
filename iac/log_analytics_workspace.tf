resource "azurerm_log_analytics_workspace" "demo-law" {
  location            = azurerm_resource_group.demo-rg.location
  resource_group_name = azurerm_resource_group.demo-rg.name
  name                = "demo-law-${var.group_key}-${var.env_id}"
  sku                 = "PerGB2018"
  retention_in_days   = 30 # 7 free, or 30 to 730

  tags = {
    environment = var.env_id
    source      = var.source_key
    group_key   = var.group_key
  }
}
