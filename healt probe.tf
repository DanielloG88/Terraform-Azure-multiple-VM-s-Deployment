resource "azurerm_lb_probe" "example" {
  resource_group_name = azurerm_resource_group.Rg_name.name
  loadbalancer_id     = azurerm_lb.LoadBalancer.id
  name                = "ssh-running-probe"
  port                = 22
}