#creating master nodes
resource "aws_instance" "master-nodes" {
  count                  = var.instance-count
  ami                    = var.ubuntu-ami
  instance_type          = var.instance-Type
  vpc_security_group_ids = var.master-node-sg
  subnet_id              = element(var.prvsubnet-id, count.index)
  key_name               = var.key-name

  tags = {
    Name = "${var.instance_worker}${count.index}"
  }
}