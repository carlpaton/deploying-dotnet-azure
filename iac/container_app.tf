resource "azurerm_container_app" "demo-aca" {
  container_app_environment_id = azurerm_container_app_environment.demo-cae.id
  name                         = "demo-aca${var.env_id}"
  resource_group_name          = azurerm_resource_group.demo-rg.name
  revision_mode                = "Multiple"

  template {
    min_replicas = 1
    max_replicas = 3

    container {
      name   = "demo-app-${var.env_id}"
      image  = "mcr.microsoft.com/k8se/quickstart:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  # K8s will run in a walled garden, so we need to provide an ingress to access the app
  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 8080

    traffic_weight {
      percentage = 100
      label = "primary"
      latest_revision = true
    }
  }

  tags = {
    environment = var.env_id
    source      = var.source_key
  }
}
