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
  default = 1
}
variable "Ports" {
  type    = set(string)
  default = [22, 443, 80]
}