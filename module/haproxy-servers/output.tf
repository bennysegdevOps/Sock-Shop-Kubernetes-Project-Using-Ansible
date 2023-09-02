output "HAproxy_private_IP" {
  value = aws_instance.haproxy.private_ip
}

output "HAproxybackup_private_IP" {
  value = aws_instance.haproxy-backup.private_ip
}