
resource "azurerm_postgresql_flexible_server" "resolv-psql" {
  name                   = "demo-psql-flex-${var.group_key}-${var.env_id}"
  resource_group_name    = azurerm_resource_group.demo-rg.name
  location               = azurerm_resource_group.demo-rg.location
  administrator_login    = var.sql_user
  administrator_password = var.sql_pass

  sku_name   = "B_Standard_B1ms"
  storage_mb = 32768 # Minimum storage
  version    = "16"

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  zone                         = 1 # South Africa North only supports zone 1

  tags = {
    environment = var.env_id
    source      = var.source_key
    group_key   = var.group_key
  }
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "resolv-psql-firewall" {
  name             = "firewall-psql-${var.env_id}"
  server_id        = azurerm_postgresql_flexible_server.resolv-psql.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
