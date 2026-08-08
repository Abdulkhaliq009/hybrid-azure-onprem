output "frontdoor_url" {
  value       = module.frontdoor.endpoint_url
  description = "Your Front Door URL - test with curl"
}

output "vpn_gateway_public_ip" {
  value       = module.vpn.gateway_public_ip
  description = "Paste this into your on-prem VPN config"
}

output "app_service_url" {
  value       = module.appservice.hostname
  description = "Direct App Service URL (bypass Front Door for testing)"
}
