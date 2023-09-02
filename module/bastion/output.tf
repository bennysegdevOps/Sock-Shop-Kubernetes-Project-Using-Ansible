output "bastion-ip" {
  value = aws_instance.Bastion-Host.public_ip
}