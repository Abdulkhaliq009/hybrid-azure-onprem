# Run AFTER terraform apply
# Pass the VPN Gateway public IP from Terraform output as parameter
# Usage: .\02-configure-vpn.ps1 -AzureVpnGatewayIp "1.2.3.4"

param(
  [Parameter(Mandatory)][string]$AzureVpnGatewayIp
)

$ErrorActionPreference = "Stop"

$SharedKey   = "HybridLabSharedKey123!"
$AzureSubnet = "10.10.0.0/16"

Write-Host "Installing RRAS role..."
Install-WindowsFeature RemoteAccess, RRAS, RRAS-Role -IncludeManagementTools

Write-Host "Configuring RRAS for VPN..."
& netsh routing ip install

Write-Host "Adding S2S VPN connection to Azure Gateway: $AzureVpnGatewayIp"
Add-VpnS2SInterface `
  -Name "AzureS2S" `
  -Destination $AzureVpnGatewayIp `
  -Protocol IKEv2 `
  -AuthenticationMethod PSKOnly `
  -SharedSecret $SharedKey `
  -IPv4Subnet "$AzureSubnet`:100"

Write-Host "Connecting tunnel..."
Connect-VpnS2SInterface -Name "AzureS2S"

Write-Host "Done. Check tunnel status with:"
Write-Host "  Get-VpnS2SInterface -Name AzureS2S"
