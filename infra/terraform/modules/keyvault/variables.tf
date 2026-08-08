variable "resource_group_name"        { type = string }
variable "location"                   { type = string }
variable "app_service_principal_id"   { type = string }
variable "private_endpoint_subnet_id" { type = string }
variable "db_password" {
  type      = string
  sensitive = true
}
variable "db_user" { type = string }
