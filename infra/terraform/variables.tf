variable "resource_group_name" {
  type    = string
  default = "rg-hybrid-lab"
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "onprem_public_ip" {
  type        = string
  description = "Your home/lab public IP address"
}

variable "onprem_address_space" {
  type        = string
  description = "Your on-prem LAN subnet e.g. 192.168.1.0/24"
}

variable "onprem_db_host" {
  type        = string
  description = "Private IP of your Windows Server on-prem"
}

variable "db_name" {
  type    = string
  default = "labdb"
}

variable "db_user" {
  type        = string
  description = "SQL Server login username"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "SQL Server login password"
}

variable "alert_email" {
  type        = string
  description = "Email address for Azure Monitor alerts and Defender for Cloud"
}

variable "security_contact_phone" {
  type        = string
  description = "Phone number for Defender for Cloud security alerts"
  default     = "+49000000000"
}
