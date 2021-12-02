# Terraform-Deployment
Deployment of several Ubuntu VM with NGINX and a Load Balancer on Azure.
This script makes it possible to deploy on Azure "X" number of identical machines with a public load balancer and an NSG applied to each NIC.
To change the number of machines go to the file "variables.tf" and on the value "Node_count" enter the desired number of virtual machines.
The NSG is used to limit the IPs that can access the machines.
