# Create Route53 Hosted Zone
data "aws_route53_zone" "route53" {
  name         = var.domain_name
  private_zone = false
}

# Create A Record For Production Environment
resource "aws_route53_record" "production_record" {
  zone_id = data.aws_route53_zone.route53.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.prod_lb_dns_name
    zone_id                = var.prod_lb_zone_id
    evaluate_target_health = true
  }
}

# Create A Record For Stage Environment
resource "aws_route53_record" "stage_record" {
  zone_id = data.aws_route53_zone.route53.zone_id
  name    = var.stage_domain_name
  type    = "A"

  alias {
    name                   = var.stage_lb_dns_name
    zone_id                = var.stage_lb_zone_id
    evaluate_target_health = true
  }
}

# Create A Record For Prometheus
resource "aws_route53_record" "prometheus_record" {
  zone_id = data.aws_route53_zone.route53.zone_id 
  name    = var.prometheus_domain_name
  type    = "A"

  alias {
    name                   = var.prometheus_lb_dns_name
    zone_id                = var.prometheus_lb_zone_id
    evaluate_target_health = true
  }
}

# Create A Record For Grafana
resource "aws_route53_record" "grafana_record" {
  zone_id = data.aws_route53_zone.route53.zone_id 
  name    = var.grafana_domain_name
  type    = "A"

  alias {
    name                   = var.grafana_lb_dns_name
    zone_id                = var.grafana_lb_zone_id
    evaluate_target_health = true
  }
}
