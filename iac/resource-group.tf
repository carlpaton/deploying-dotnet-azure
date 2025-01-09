resource "azurerm_resource_group" "demo-rg" {
  location = var.location
  name     = "demo-rg-${var.group_key}-${var.env_id}"

  tags = {
    environment = var.env_id
    source      = var.source_key
    group_key   = var.group_key
    testtag     = "testtag5"
  }
}
