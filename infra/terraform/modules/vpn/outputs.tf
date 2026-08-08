output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "vnet_name" {
  value = azurerm_virtual_network.main.name
}

output "appservice_subnet_id" {
  value = azurerm_subnet.appservice.id
}

output "private_endpoint_subnet_id" {
  value = azurerm_subnet.private_endpoints.id
}

output "gateway_public_ip" {
  value = azurerm_public_ip.vpn_gateway.ip_address
}
