# Architecture

## Overview

This project replicates a production-grade hybrid architecture where:
- Azure acts as the public-facing cloud layer (Front Door, App Service)
- An on-premises Windows Server 2025 acts as the data tier (SQL Server Express)
- A Site-to-Site VPN connects both environments over an encrypted IPSec tunnel

## Traffic flow

1. User sends request to Front Door URL
2. Front Door applies WAF rules, caches static content, routes to nearest healthy origin
3. Request hits App Service (Node.js API)
4. App Service queries SQL Server over the VPN tunnel (private IP, port 1433)
5. Response returns the same path in reverse

## Network layout

| Network | CIDR |
|---|---|
| Azure VNet | 10.10.0.0/16 |
| Gateway subnet | 10.10.0.0/27 |
| App Service subnet | 10.10.1.0/24 |
| On-premises LAN | 192.168.1.0/24 (update to match your lab) |

## Key Azure resources

| Resource | Purpose |
|---|---|
| Azure Front Door (Standard) | CDN, WAF, global load balancing |
| App Service Plan (B1 Linux) | Hosts Node.js API |
| VPN Gateway (VpnGw1) | Terminates the IPSec tunnel on Azure side |
| Local Network Gateway | Tells Azure where your on-prem network is |
| VNet Integration | Allows App Service to reach private IPs in VNet |

## Cost estimate (while running)

| Resource | Approx cost/hour |
|---|---|
| VPN Gateway VpnGw1 | ~$0.19/hr |
| App Service B1 | ~$0.018/hr |
| Front Door Standard | ~$0.01/hr + traffic |
| Total | ~$0.22/hr |

Run `terraform destroy` when done to avoid charges.
