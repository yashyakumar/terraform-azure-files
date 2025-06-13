data "azurerm_platform_image" "ubuntu" {
  location  = "Central India"
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-jammy"
  sku       = "22_04-lts"
}
data "azurerm_virtual_network" "default" {
  name                = "default"
  resource_group_name = "Terra-Test"
}

data "azurerm_subnet" "default" {
  name                 = "default"
  virtual_network_name = data.azurerm_virtual_network.default.name
  resource_group_name  = data.azurerm_virtual_network.default.resource_group_name

}

output "subnet_id" {
  value = data.azurerm_subnet.default.id
}

output "virtual_network_id" {
  value = data.azurerm_virtual_network.default.id
}

output "image_id" {
  value = data.azurerm_platform_image.ubuntu.id
}

output "resource_group_name" {
  value = data.azurerm_virtual_network.default.resource_group_name
  
}

output "location" {
  value = data.azurerm_platform_image.ubuntu.location
}