output "key_vault_id" {
  value = azurerm_key_vault.main.id
}

output "key_vault_uri" {
  value = azurerm_key_vault.main.vault_uri
}

output "db_password_secret_uri" {
  value = azurerm_key_vault_secret.db_password.id
}
