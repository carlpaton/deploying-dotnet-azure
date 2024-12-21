resource "azurerm_mssql_server" "demo-sql" {
  location                     = azurerm_resource_group.demo-rg.location
  name                         = "demo-sql-${env_id}"
  resource_group_name          = azurerm_resource_group.demo-rg.name
  version                      = "12.0"
  administrator_login          = var.sql_user
  administrator_login_password = var.sql_pass
  minimum_tls_version          = "1.2"

  tags = {
    environment = var.env_id
    source      = var.source_key
  }
}

resource "azurerm_mssql_database" "demo-db" {
  name           = "demo-db"
  server_id      = azurerm_mssql_server.demo-sql.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 10
  sku_name       = "S1"
  zone_redundant = false

  lifecycle {
    # set to true for a prod db
    prevent_destroy = false
  }

  tags = {
    environment = var.env_id
    source      = var.source_key
  }
}

# this allows access from anywhere in Azure and external
resource "azurerm_mssql_firewall_rule" "demo-rule" {
  end_ip_address   = "0.0.0.0"
  name             = "all_azure"
  server_id        = azurerm_mssql_server.demo-sql.id
  start_ip_address = "0.0.0.0"
}
