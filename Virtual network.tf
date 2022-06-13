resource "azurerm_virtual_network" "AZ_VirtualNetwork" {
  name                = var.NetworkName
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.Rg_name.location
  resource_group_name = azurerm_resource_group.Rg_name.name
}

