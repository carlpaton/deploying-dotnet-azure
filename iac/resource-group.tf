resource "azurerm_resource_group" "demo-rg" {
  location = "Australia East"
  name     = "demo-rg"

  tags = {
    environment = var.env_id
    source      = var.source_key
  }
}
