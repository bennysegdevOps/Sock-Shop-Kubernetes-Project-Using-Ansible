#Variable.tf
variable "instance-count" {}
variable "ami-ubuntu" {}
variable "instanceType" {}
variable "worker-node-sg" {}
variable "prvsub-id" {type = list(string)}
variable "pub-key" {}
variable "instance_worker" {}