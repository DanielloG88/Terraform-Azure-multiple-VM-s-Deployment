resource "azurerm_lb" "LoadBalancer" {
  name                = "LoadBalancer"
  location            = var.location
  resource_group_name = azurerm_resource_group.Rg_name.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.LoadBalPubIP.id
  }
}
resource "azurerm_public_ip" "LoadBalPubIP" {
  name                = "PublicIpForLB"
  location            = azurerm_resource_group.Rg_name.location
  resource_group_name = azurerm_resource_group.Rg_name.name
  allocation_method   = "Static"
  sku                 = "standard"
}
resource "azurerm_lb_backend_address_pool" "LB_backend" {
  loadbalancer_id = azurerm_lb.LoadBalancer.id
  name            = "BackEndAddressPool"
}
resource "azurerm_network_interface_backend_address_pool_association" "LB_Backend_AddressPool" {
  count                   = var.Node_count
  network_interface_id    = element(azurerm_network_interface.NetworkInt.*.id, count.index)
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.LB_backend.id
}

locals {
  web_inbound_roules_maps = {
    "1" : "22",
    "2" : "80",
    "3" : "443"
  }
}
resource "azurerm_lb_rule" "Port" {
  resource_group_name            = azurerm_resource_group.Rg_name.name
  loadbalancer_id                = azurerm_lb.LoadBalancer.id
  for_each                       = local.web_inbound_roules_maps
  name                           = "LBRule_Port-${each.value}"
  protocol                       = "Tcp"
  frontend_port                  =  each.value
  backend_port                   =  each.value
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.LB_backend.id]
  probe_id                       = azurerm_lb_probe.example.id
}

resource "azurerm_lb_probe" "example" {
  resource_group_name = azurerm_resource_group.Rg_name.name
  loadbalancer_id     = azurerm_lb.LoadBalancer.id
  name                = "ssh-running-probe"
  port                = 22
}
