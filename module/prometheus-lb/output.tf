output "prometheus-dns-name" {
  value = aws_lb.prometheus-alb.dns_name
}

output "prometheus-zoneid" {
  value = aws_lb.prometheus-alb.zone_id
}