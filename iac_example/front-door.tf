# ─── Front Door Profile ───────────────────────────────────────────────────────

resource "azurerm_cdn_frontdoor_profile" "demo-afd" {
  name                     = "demo-afd-${var.group_key}-${var.env_id}"
  resource_group_name      = azurerm_resource_group.demo-rg.name
  sku_name                 = "Standard_AzureFrontDoor"
  response_timeout_seconds = 120

  tags = {
    environment = var.env_id
    source      = var.source_key
  }
}

# ─── Endpoint ────────────────────────────────────────────────────────────────

resource "azurerm_cdn_frontdoor_endpoint" "demo-afd-ep" {
  name                     = "demo-afd-${var.group_key}-${var.env_id}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.demo-afd.id

  tags = {
    environment = var.env_id
    source      = var.source_key
  }
}

# ─── Origin Group ────────────────────────────────────────────────────────────

resource "azurerm_cdn_frontdoor_origin_group" "demo-afd-og" {
  name                     = "demo-afd-${var.group_key}-${var.env_id}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.demo-afd.id
  session_affinity_enabled = false

  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 10

  health_probe {
    interval_in_seconds = 100
    path                = "/"
    protocol            = "Https"
    request_type        = "HEAD"
  }

  load_balancing {
    additional_latency_in_milliseconds = 0
    sample_size                        = 4
    successful_samples_required        = 3
  }
}

# ─── Origin (Container App) ───────────────────────────────────────────────────

resource "azurerm_cdn_frontdoor_origin" "demo-afd-origin" {
  name                          = "demo-afd-${var.group_key}-${var.env_id}"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.demo-afd-og.id
  enabled                       = true

  certificate_name_check_enabled = true

  host_name          = azurerm_container_app.demo-aca.ingress[0].fqdn
  http_port          = 80
  https_port         = 443
  origin_host_header = azurerm_container_app.demo-aca.ingress[0].fqdn
  priority           = 1
  weight             = 1000
}

# ─── Custom Domain ────────────────────────────────────────────────────────────

resource "azurerm_cdn_frontdoor_custom_domain" "demo-afd-cd" {
  name                     = "demo-afd-${var.group_key}-${var.env_id}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.demo-afd.id
  host_name                = "demo.it.com"

  tls {
    certificate_type    = "ManagedCertificate"
    minimum_tls_version = "TLS12"
  }
}

# ─── Route ───────────────────────────────────────────────────────────────────

resource "azurerm_cdn_frontdoor_route" "demo-afd-route" {
  name                          = "demo-afd-${var.group_key}-${var.env_id}"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.demo-afd-ep.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.demo-afd-og.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.demo-afd-origin.id]
  enabled                       = true

  forwarding_protocol    = "HttpsOnly"
  https_redirect_enabled = true
  patterns_to_match      = ["/*"]
  supported_protocols    = ["Http", "Https"]

  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.demo-afd-cd.id]
  link_to_default_domain          = false
}

resource "azurerm_cdn_frontdoor_custom_domain_association" "demo-afd-cda" {
  cdn_frontdoor_custom_domain_id = azurerm_cdn_frontdoor_custom_domain.demo-afd-cd.id
  cdn_frontdoor_route_ids        = [azurerm_cdn_frontdoor_route.demo-afd-route.id]
}

output "afd_endpoint_hostname" {
  description = "Front Door endpoint hostname to use as CNAME target (e.g. demo-afd.azurefd.net)."
  value       = azurerm_cdn_frontdoor_endpoint.demo-afd-ep.host_name
}

output "afd_custom_domain_validation_token" {
  description = "Validation token value for GoDaddy TXT record _dnsauth.demo."
  value       = azurerm_cdn_frontdoor_custom_domain.demo-afd-cd.validation_token
}
