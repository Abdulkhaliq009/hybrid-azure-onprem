output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "appservice_subnet_id" {
  value = azurerm_subnet.appservice.id
}

output "gateway_public_ip" {
  value = azurerm_public_ip.vpn_gateway.ip_address
}
