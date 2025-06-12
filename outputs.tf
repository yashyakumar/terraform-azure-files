output "az_instance_id" {
  value = azurerm_linux_virtual_machine.test.id
}

output "az_instance_ip" {
    value = azurerm_linux_virtual_machine.test.public_ip_address
  
}

output "az_instance" {
    value = azurerm_linux_virtual_machine.test
  
}