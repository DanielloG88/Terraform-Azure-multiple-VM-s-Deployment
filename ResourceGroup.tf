resource "azurerm_resource_group" "Rg_name" {
  name     = "Rg_Test"
  location = var.location
}