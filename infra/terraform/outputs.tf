output "frontdoor_url" {
  value       = module.frontdoor.endpoint_url
  description = "Front Door URL - test with curl"
}

output "vpn_gateway_public_ip" {
  value       = module.vpn.gateway_public_ip
  description = "Paste into on-prem VPN config"
}

output "app_service_url" {
  value       = module.appservice.hostname
  description = "Direct App Service URL"
}

output "key_vault_uri" {
  value       = module.keyvault.key_vault_uri
  description = "Key Vault URI"
}

output "log_analytics_workspace_id" {
  value       = module.monitoring.log_analytics_workspace_id
  description = "Log Analytics workspace ID"
}

output "app_insights_connection_string" {
  value     = module.monitoring.app_insights_connection_string
  sensitive = true
  description = "Add this to your Node.js app"
}
