resource "azurerm_network_interface" "test" {
  name                = "test-nic"
  location            = data.azurerm_platform_image.ubuntu.location
  resource_group_name = data.azurerm_virtual_network.default.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "test" {
  name                = "test-machine"
  resource_group_name = data.azurerm_virtual_network.default.resource_group_name
  location            = data.azurerm_virtual_network.default.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.test.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = data.azurerm_platform_image.ubuntu.id
}