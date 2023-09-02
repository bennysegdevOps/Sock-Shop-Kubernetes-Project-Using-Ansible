#PROVISIONING WORKER NODE
resource "aws_instance" "worker_nodes" {
  count                  = var.instance-count
  ami                    = var.ami-ubuntu
  instance_type          = var.instanceType
  vpc_security_group_ids = var.worker-node-sg
  subnet_id              = element(var.prvsub-id, count.index)
  key_name               = var.pub-key

  tags = {
    Name = "${var.instance_worker}${count.index}"
  }
}