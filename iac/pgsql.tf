resource "azurerm_postgresql_server" "demo-pgsql" {
  name                = "demo-pgsql-${var.group_key}-${var.env_id}"
  location            = azurerm_resource_group.demo-rg.location
  resource_group_name = azurerm_resource_group.demo-rg.name

  sku_name = "B_Gen4_1"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = var.sql_user
  administrator_login_password = var.sql_pass
  version                      = "9.5"
  ssl_enforcement_enabled      = true

  tags = {
    environment = var.env_id
    source      = var.source_key
    group_key   = var.group_key
  }
}

resource "azurerm_postgresql_database" "demo-db" {
  name                = "demo-db-psql"
  resource_group_name = azurerm_resource_group.demo-rg.name
  server_name         = azurerm_postgresql_server.demo-pgsql.name
  charset             = "UTF8"
  collation           = "English_United States.1252"

  lifecycle {
    # set to true for a prod db
    prevent_destroy = false
  }
}

# this allows access from anywhere in Azure
resource "azurerm_postgresql_firewall_rule" "demo-rule-pgsql" {
  name                = "all_azure-pgsql"
  resource_group_name = azurerm_resource_group.demo-rg.name
  server_name         = azurerm_postgresql_server.demo-pgsql.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}
