output "master-nodes_priv-ip" {
  value = aws_instance.master-nodes.*.private_ip
}