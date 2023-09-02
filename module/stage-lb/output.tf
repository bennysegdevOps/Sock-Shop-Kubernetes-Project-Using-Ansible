output "stage-dns-name" {
  value = aws_lb.stage-alb.dns_name
}

output "stage-zoneid" {
  value = aws_lb.stage-alb.zone_id
}