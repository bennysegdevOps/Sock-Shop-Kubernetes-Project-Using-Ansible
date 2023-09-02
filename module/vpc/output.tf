output "vpc-id" {
  value = aws_vpc.vpc.id
}
output "public-subnet1" {
  value = aws_subnet.public_subnet1.id
}
output "public-subnet2" {
  value = aws_subnet.public_subnet2.id
}

output "public-subnet3" {
  value = aws_subnet.public_subnet3.id
}
output "private-subnet1" {
  value = aws_subnet.private_subnet1.id
}
output "private-subnet2" {
  value = aws_subnet.private_subnet2.id
}
output "private-subnet3" {
  value = aws_subnet.private_subnet3.id
}
output "keypairid" {
  value = aws_key_pair.key_pair.id
}
output "privatekeypair" {
  value = tls_private_key.keypair.private_key_pem
}
output "Bastion_Ansible_SG" {
  value = aws_security_group.Bastion_Ansible_SG.id
}
output "master-worker-SG" {
  value = aws_security_group.master-worker-SG.id
}
output "jenkins_sg" {
  value = aws_security_group.Jenkins_SG.id
}