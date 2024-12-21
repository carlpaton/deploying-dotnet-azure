resource "azurerm_log_analytics_workspace" "demo-law" {
  location            = azurerm_resource_group.demo-rg.location
  resource_group_name = azurerm_resource_group.demo-rg.name
  name                = "demo-law${var.env_id}"
  sku                 = "PerGB2018"
  retention_in_days   = 7 # free tier is 7 else needs to be 30 to 730
}