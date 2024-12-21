resource "azurerm_container_registry" "demo-acr" {
  location                      = azurerm_resource_group.demo-rg.location
  name                          = "demoacr${var.env_id}"
  resource_group_name           = azurerm_resource_group.demo-rg.name
  sku                           = "Standard"
  admin_enabled                 = true # allows credentials to access
  public_network_access_enabled = true # need to access from github actions

  tags = {
    environment = var.env_id
    source      = var.source_key
  }
}
