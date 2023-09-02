# Create ec2 instance for ansible
resource "aws_instance" "ansible-server" {
  ami                       = var.ami_ubuntu
  instance_type             = var.instance_type
  key_name                  = var.key_name
  vpc_security_group_ids    = var.ansible-sg
 # associate_public_ip_address = true
  subnet_id                 = var.subnet_id
  user_data = templatefile("./module/ansible/userdata.sh", {
    prv_key     =var.prv_key,
    HAProxy1_IP =var.HAProxy1_IP,
    HAProxy2_IP =var.HAProxy2_IP,
    master1_IP  =var.master1_IP,
    master2_IP  =var.master2_IP,
    master3_IP  =var.master3_IP,
    worker1_IP  =var.worker1_IP,
    worker2_IP  =var.worker2_IP,
    worker3_IP  =var.worker3_IP
  })

  tags = {
    Name = var.ansible_server
  }
}

# Create null resource to copy playbooks directory into ansible server
resource "null_resource" "copy-playbooks" {
  connection {
    type                = "ssh"
    host                = aws_instance.ansible-server.private_ip
    user                = "ubuntu"
    private_key         = var.prv_key
    bastion_host        = var.bastion_host
    bastion_user        = "ubuntu"
    bastion_private_key = var.prv_key
  }

  provisioner "file" {
    source      = "./module/ansible/playbooks"
    destination = "/home/ubuntu/playbooks"
  }
}