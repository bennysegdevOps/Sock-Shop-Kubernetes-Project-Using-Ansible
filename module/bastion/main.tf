# creating Bastian Host 
resource "aws_instance" "Bastion-Host" {
  ami                       = var.ami
  vpc_security_group_ids    = var.bastion-SG
  instance_type             = var.instance_type
  key_name                  = var.key_name
  subnet_id                 = var.subnetid
  associate_public_ip_address = true
  user_data                 = <<-EOF
  #!/bin/bash
  echo "pubkeyAcceptedkeyTypes=+ssh-rsa" >> /etc/ssh/sshd_config.d/10-insecure-rsa-keysig.conf
  systemctl reload sshd
  echo "${var.private_keypair_path}" >> /home/ubuntu/.ssh/id_rsa
  chown ubuntu /home/ubuntu/.ssh/id_rsa
  chgrp ubuntu /home/ubuntu/.ssh/id_rsa
  chmod 600 /home/ubuntu/.ssh/id_rsa
  sudo hostnamectl set-hostname Bastion
  EOF 
  tags = {
    Name = var.tags
  }
}


