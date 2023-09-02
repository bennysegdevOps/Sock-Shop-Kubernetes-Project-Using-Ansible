# vpc variables
variable "vpc_cidr" {}
variable "tag-vpc" {}
variable "public_subnet1_cidr" {}
variable "public_subnet2_cidr" {}
variable "public_subnet3_cidr" {}
variable "private_subnet1_cidr" {}
variable "private_subnet2_cidr" {}
variable "private_subnet3_cidr" {}
variable "tag-public_subnet1" {}
variable "tag-public_subnet2" {}
variable "tag-public_subnet3" {}
variable "tag-private_subnet1" {}
variable "tag-private_subnet2" {}
variable "tag-private_subnet3" {}
variable "tag-igw" {}
variable "tag-natgw" {}
variable "az1" {}
variable "az2" {}
variable "az3" {}
variable "rt-cidr" {}
variable "port_ssh" {}
variable "RT_cidr" {}
variable "port" {}
variable "Bastion_Ansible_SG" {}
variable "port_proxy" {}
variable "port_https" {}
variable "node-port" {}
variable "node-port2" {}
variable "master-worker-SG" {}
variable "Jenkins_SG" {}