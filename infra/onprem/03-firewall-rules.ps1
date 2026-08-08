# Run on Windows Server as Administrator

$ErrorActionPreference = "Stop"

Write-Host "Opening port 1433 for SQL Server..."
New-NetFirewallRule `
  -DisplayName "SQL Server 1433 Inbound" `
  -Direction Inbound `
  -Protocol TCP `
  -LocalPort 1433 `
  -Action Allow `
  -Profile Any

Write-Host "Opening IKE/IPSec ports for VPN..."
New-NetFirewallRule `
  -DisplayName "IKE UDP 500" `
  -Direction Inbound `
  -Protocol UDP `
  -LocalPort 500 `
  -Action Allow

New-NetFirewallRule `
  -DisplayName "IPSec NAT-T UDP 4500" `
  -Direction Inbound `
  -Protocol UDP `
  -LocalPort 4500 `
  -Action Allow

Write-Host "All firewall rules added."
Get-NetFirewallRule | Where-Object DisplayName -like "*SQL*" | Select DisplayName, Enabled, Direction
