# Architecture

## Overview

Production-grade hybrid architecture where Azure acts as the public-facing cloud layer and an on-premises Windows Server 2025 acts as the data tier, connected via Site-to-Site VPN.

## Traffic flow

1. User request hits Azure Front Door (nearest CDN edge)
2. Front Door applies WAF rules, routes to healthy App Service origin
3. App Service (Node.js) processes the request
4. App Service fetches secrets from Key Vault via Managed Identity (no passwords in code)
5. App Service queries SQL Server over the VPN tunnel (private IP, port 1433)
6. Response returns the same path in reverse
7. All telemetry flows to Application Insights and Log Analytics

## Network layout

| Network | CIDR | Purpose |
|---|---|---|
| Azure VNet | 10.10.0.0/16 | All Azure resources |
| Gateway subnet | 10.10.0.0/27 | VPN Gateway (required name) |
| App Service subnet | 10.10.1.0/24 | VNet Integration |
| Bastion subnet | 10.10.2.0/27 | Azure Bastion (required name) |
| Private endpoint subnet | 10.10.3.0/24 | Key Vault private endpoint |
| On-premises LAN | 192.168.1.0/24 | Windows Server 2025 |

## Azure resources

| Resource | Purpose |
|---|---|
| Azure Front Door Standard | CDN, WAF, global load balancing |
| App Service Plan (B1 Linux) | Hosts Node.js API |
| App Service Managed Identity | Passwordless access to Key Vault |
| Azure Key Vault | Stores DB credentials as secrets |
| Private Endpoint (Key Vault) | Key Vault accessible only within VNet |
| VPN Gateway (VpnGw1) | Terminates IPSec tunnel on Azure side |
| Local Network Gateway | Tells Azure where on-prem network is |
| Azure Bastion | Secure RDP/SSH without public port 3389 |
| Log Analytics Workspace | Centralized log storage, KQL queries |
| Application Insights | APM — request traces, exceptions, perf |
| Azure Monitor | Alerts on 5xx errors and slow responses |
| Defender for Cloud | Security posture score, threat detection |

## Security improvements vs v1

| v1 | v2 |
|---|---|
| DB password in app settings (plain text) | DB password in Key Vault, fetched via Managed Identity |
| Key Vault accessible over internet | Key Vault behind private endpoint — VNet only |
| No RDP security | Azure Bastion — RDP over HTTPS, no port 3389 |
| No threat detection | Defender for Cloud on servers, SQL, App Service |
| No observability | App Insights + Log Analytics + Monitor alerts |

## Cost estimate (while running)

| Resource | Approx cost/hr |
|---|---|
| VPN Gateway VpnGw1 | ~$0.19 |
| App Service B1 | ~$0.018 |
| Front Door Standard | ~$0.01 |
| Azure Bastion Basic | ~$0.19 |
| Log Analytics (minimal data) | ~$0.01 |
| Key Vault | ~$0.001 |
| Defender for Cloud | ~$0.02 |
| Total | ~$0.44/hr |

Run `terraform destroy` when done to avoid charges.
