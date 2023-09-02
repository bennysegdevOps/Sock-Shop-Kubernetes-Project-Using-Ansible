output "grafana-dns-name" {
  value = aws_lb.grafana-alb.dns_name
}

output "grafana-zoneid" {
  value = aws_lb.grafana-alb.zone_id
}
