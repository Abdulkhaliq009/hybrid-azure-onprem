variable "resource_group_name"         { type = string }
variable "location"                    { type = string }
variable "vnet_id"                     { type = string }
variable "subnet_id"                   { type = string }
variable "db_host"                     { type = string }
variable "db_name"                     { type = string }
variable "db_user" {
  type      = string
  sensitive = true
}
variable "db_password" {
  type      = string
  sensitive = true
}
variable "db_user_secret_uri"          { type = string default = "" }
variable "db_password_secret_uri"      { type = string default = "" }
variable "app_insights_connection_string" { type = string default = "" sensitive = true }
