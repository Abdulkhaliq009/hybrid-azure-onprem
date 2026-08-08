variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "vnet_id"             { type = string }
variable "subnet_id"           { type = string }
variable "db_host"             { type = string }
variable "db_name"             { type = string }
variable "db_user"             { type = string }
variable "db_password" {
  type      = string
  sensitive = true
}
