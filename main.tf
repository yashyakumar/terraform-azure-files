resource "azurerm_network_interface" "test" {
  name                = "test-nic"
  location            = data.azurerm_platform_image.ubuntu.location
  resource_group_name = data.azurerm_virtual_network.default.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
    
  
  }
}

resource "azurerm_linux_virtual_machine" "test" {
  count = var.instance_count
  name                = "${var.name_prefix}-${count.index}"
  resource_group_name = data.azurerm_virtual_network.default.resource_group_name
  location            = data.azurerm_virtual_network.default.location
  size                = var.instance_type
  admin_username      = "adminuser"

  network_interface_ids = [
    azurerm_network_interface.test.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("C:/Users/JYOTHI/Documents/test/terraform/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = data.azurerm_platform_image.ubuntu.publisher
    version = "latest"
    offer = data.azurerm_platform_image.ubuntu.offer
    sku = data.azurerm_platform_image.ubuntu.sku
    
  }

  dynamic "identity" {
    for_each = length(var.user_assigned_identities) >0?[1]:[] #It will ensure that it will run one time if the identities are not 0
    content {
      type = "UserAssigned"
      identity_ids = var.user_assigned_identities
    }
    
  }
}



resource "azurerm_public_ip" "test_ip" {
  name                = "test_ip"
  location            = data.azurerm_virtual_network.default.location
  resource_group_name = data.azurerm_virtual_network.default.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_subnet" "bast_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  =data.azurerm_virtual_network.default.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.1.0/27"]
}

resource "azurerm_bastion_host" "example" {
  name                = "examplebastion"
  location            = data.azurerm_virtual_network.default.location
  resource_group_name = data.azurerm_virtual_network.default.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bast_subnet.id
    public_ip_address_id = azurerm_public_ip.test_ip.id
  }
}