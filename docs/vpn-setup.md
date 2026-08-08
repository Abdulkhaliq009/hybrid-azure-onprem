# VPN Setup Guide

## Prerequisites

- Windows Server 2025 with a public IP (or port-forwarded NAT)
- Azure VPN Gateway deployed (from terraform apply)
- Shared key: HybridLabSharedKey123! (matches terraform config)

## On-premises side (Windows Server 2025)

### 1. Install RRAS

Run in PowerShell as Administrator:

```powershell
Install-WindowsFeature RemoteAccess, RRAS, RRAS-Role -IncludeManagementTools
```

Or use the script: `infra/onprem/02-configure-vpn.ps1`

### 2. Configure the S2S interface

```powershell
Add-VpnS2SInterface `
  -Name "AzureS2S" `
  -Destination "AZURE_VPN_GATEWAY_PUBLIC_IP" `
  -Protocol IKEv2 `
  -AuthenticationMethod PSKOnly `
  -SharedSecret "HybridLabSharedKey123!" `
  -IPv4Subnet "10.10.0.0/16:100"
```

### 3. Connect

```powershell
Connect-VpnS2SInterface -Name "AzureS2S"
```

### 4. Verify tunnel status

```powershell
Get-VpnS2SInterface -Name "AzureS2S"
# ConnectionState should show: Connected
```

## Verify end-to-end connectivity

From Windows Server, ping an Azure VNet IP:
```
ping 10.10.1.4
```

From App Service console (Azure Portal), test DB connection:
```
curl http://localhost/products
```

## Troubleshooting

| Symptom | Fix |
|---|---|
| Tunnel not connecting | Check Windows Firewall - UDP 500 and 4500 must be open |
| SQL connection refused | Confirm TCP/IP enabled in SQL Server Config Manager |
| App Service can't reach DB | Confirm VNet Integration is enabled on App Service |
| Wrong IP in tunnel | Re-run 02-configure-vpn.ps1 with correct gateway IP |
