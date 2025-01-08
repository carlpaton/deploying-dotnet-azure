resource "azurerm_resource_group" "demo-rg" {
  location = var.location
  name     = "demo-rg"

  tags = {
    environment = var.env_id
    source      = var.source_key
  }
}
