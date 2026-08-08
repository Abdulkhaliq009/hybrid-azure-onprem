# Hybrid Azure + On-Premises Architecture

Production-grade hybrid architecture connecting Azure Front Door and App Service to an on-premises SQL Server via Site-to-Site VPN.

## Architecture
## Stack

| Layer | Technology |
|---|---|
| Edge | Azure Front Door Standard |
| Compute | Azure App Service (Linux, Node.js) |
| Connectivity | Azure VPN Gateway + Windows RRAS |
| Database | SQL Server Express 2022 (on-premises) |
| IaC | Terraform |
| On-prem config | PowerShell |

## Repo structure

hybrid-azure-onprem/
├── infra/
│ ├── terraform/ # Azure infrastructure (Front Door, VPN Gateway, App Service)
│ │ └── modules/
│ │ ├── frontdoor/
│ │ ├── vpn/
│ │ └── appservice/
│ └── onprem/ # PowerShell scripts for Windows Server 2025
├── app/ # Node.js API (connects to on-prem SQL Server)
└── docs/ # Architecture notes and screenshots


## Deploy order

1. Run `infra/onprem/01-install-sql.ps1` on Windows Server 2025
2. Update `infra/terraform/terraform.tfvars` with your public IP and DB details
3. `cd infra/terraform && terraform init && terraform apply`
4. Copy VPN Gateway public IP from Terraform output
5. Run `infra/onprem/02-configure-vpn.ps1 -AzureVpnGatewayIp <IP>`
6. Run `infra/onprem/03-firewall-rules.ps1`
7. Run `infra/onprem/04-create-db-user.ps1`
8. Deploy app to App Service: `az webapp deploy`
9. Test: `curl https://<frontdoor-url>/health`

## Key concepts demonstrated

- Hybrid cloud connectivity via IPSec Site-to-Site VPN
- Azure Front Door as global entry point with WAF
- App Service VNet Integration for private backend access
- On-premises SQL Server as data tier (simulates enterprise data residency requirement)
- Infrastructure as Code with Terraform modules
