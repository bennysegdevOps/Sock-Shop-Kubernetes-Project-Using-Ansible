output "Worker_nodes_private_ip" {
    value = aws_instance.worker_nodes.*.private_ip
}

output "Worker_nodes_id" {
    value = aws_instance.worker_nodes.*.id
}