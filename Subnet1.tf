resource "azurerm_subnet" "Subnet_config" {
  name                 = "${var.NetworkName}Subnet"
  resource_group_name  = azurerm_resource_group.Rg_name.name
  virtual_network_name = azurerm_virtual_network.AZ_VirtualNetwork.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_network_security_group" "NSG" {
  name                = "acceptanceTestSecurityGroup1"
  location            = azurerm_resource_group.Rg_name.location
  resource_group_name = azurerm_resource_group.Rg_name.name
}

locals { 
  NSG_maps = { 
  "100" : ["22"],
  "110" : ["80"],
  "120" : ["443"]}
}

resource "azurerm_network_security_rule" "NSG_RULES" {
  for_each                   = local.NSG_maps
  name                       = "test123-${each.key}"
  priority                   = each.key
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "TCP"
  source_port_range          = "*"
  destination_port_ranges    = each.value
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name        = azurerm_resource_group.Rg_name.name
  network_security_group_name = azurerm_network_security_group.NSG.name
}

resource "azurerm_subnet_network_security_group_association" "SubnetNetworkSecurityGroup" {
  depends_on = [azurerm_lb_rule.Port]
  subnet_id = azurerm_subnet.Subnet_config.id
  network_security_group_id = azurerm_network_security_group.NSG.id
}

# resource "azurerm_network_interface_security_group_association" "SubnetNetworkSecurityGroup" {
#   depends_on = [azurerm_lb_rule.Port]
#   count = var.Node_count
#   network_interface_id                 = element(azurerm_network_interface.NetworkInt.*.id, count.index)
#   network_security_group_id = azurerm_network_security_group.NSG.id
# }