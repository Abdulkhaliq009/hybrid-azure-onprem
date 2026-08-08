# Run AFTER terraform apply — paste your VPN Gateway public IP below
param(
  [Parameter(Mandatory)][string]$AzureVpnGatewayIp
)

$ErrorActionPreference = "Stop"

Write-Host "Installing RRAS role..."
Install-WindowsFeature RemoteAccess, RRAS, RRAS-Role -IncludeManagementTools

Write-Host "Configuring RRAS for VPN..."
& netsh routing ip install
& ipconfig /all | Select-String "IPv4"

$SharedKey = "HybridLabSharedKey123!"
$LocalSubnet = "192.168.1.0/24"
$AzureSubnet = "10.10.0.0/16"

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

Write-Host "VPN tunnel initiated. Check status with: Get-VpnS2SInterface -Name AzureS2S"
