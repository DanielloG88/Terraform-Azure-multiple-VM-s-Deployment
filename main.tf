provider "azurerm" {
  version = "2.87.0"
  features {}
}
resource "azurerm_resource_group" "Rg_name" {
  name     = "Rg_Test"
  location = var.location
}

resource "azurerm_linux_virtual_machine" "AzureVM" {
  count                           = var.Node_count
  name                            = "VM${count.index}"
  resource_group_name             = azurerm_resource_group.Rg_name.name
  location                        = azurerm_resource_group.Rg_name.location
  disable_password_authentication = false
  size                            = "Standard_B1ls"
  admin_username                  = "adminuser"
  admin_password                  = "Abc12345678"
  network_interface_ids           = [element(azurerm_network_interface.NetworkInt.*.id, count.index)]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "nginxinc"
    offer     = "nginx-plus-v1-standard"
    sku       = "nginx-plus-ubuntu1804"
    version   = "latest"
  }
  plan {
    name      = "nginx-plus-ubuntu1804"
    publisher = "nginxinc"
    product   = "nginx-plus-v1-standard"
  }

}
resource "azurerm_network_interface" "NetworkInt" {
  count               = var.Node_count
  name                = "NetIntVm${count.index}"
  location            = azurerm_resource_group.Rg_name.location
  resource_group_name = azurerm_resource_group.Rg_name.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Subnet_config.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = element(azurerm_public_ip.PublicIPForVM.*.id, count.index)
  }
}
resource "azurerm_public_ip" "PublicIPForVM" {
  count               = var.Node_count
  name                = "PublicIpForVM${count.index}"
  location            = azurerm_resource_group.Rg_name.location
  resource_group_name = azurerm_resource_group.Rg_name.name
  allocation_method   = "Static"
  sku                 = "standard"
}

resource "azurerm_network_security_group" "NSG" {
  name                = "acceptanceTestSecurityGroup1"
  location            = azurerm_resource_group.Rg_name.location
  resource_group_name = azurerm_resource_group.Rg_name.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_ranges    = var.Ports
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
resource "azurerm_network_interface_security_group_association" "SubnetNetworkSecurityGroup" {
  count = var.Node_count
  network_interface_id                 = element(azurerm_network_interface.NetworkInt.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.NSG.id
}
