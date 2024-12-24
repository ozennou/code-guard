output "main_vm_ip_address" {
  value = azurerm_public_ip.main.ip_address
}

output "runner_vm_ip_address" {
  value = azurerm_public_ip.runner.ip_address
}