variable "location" {
  type    = string
  default = "northeurope"
}
variable "name" {
  type    = string
  default = "Vm1"
}
variable "NetworkName" {
  type    = string
  default = "Network1"
}
variable "Node_count" {
  type    = number
  default = 3
}
variable "Ports" {
  type    = list(number)
  default = [22, 443, 80]
}