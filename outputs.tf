output "az_instance_id" {
  value = azurerm_linux_virtual_machine.test
}

output "az_instance_ip" {
    value = {
        for i,vm in azurerm_linux_virtual_machine.test:
        vm.name => vm.public_ip_address
    }
  
}

output "az_instance" {
    value = azurerm_linux_virtual_machine.test
  
}