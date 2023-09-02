# Created grafana Application Load balancer
resource "aws_lb" "grafana-alb" {
  name               = "grafana-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets
  enable_deletion_protection = false
  tags = {
  Name = "grafana-alb"
  }
}

# Creating grafana Load balancer Listener for http
resource "aws_lb_listener" "http-listener" {
  load_balancer_arn      = aws_lb.grafana-alb.arn
  port                   = "80"
  protocol               = "HTTP"
  default_action {
    type                 = "forward"
    target_group_arn     = aws_lb_target_group.grafana-tg.arn
    }
  }

# Creating grafana Load balancer Listener for https access
resource "aws_lb_listener" "https-listener" {
  load_balancer_arn      = aws_lb.grafana-alb.arn
  port                   = "443"
  protocol               = "HTTPS"
  ssl_policy             = "ELBSecurityPolicy-2016-08"
  certificate_arn        = var.certificate
  default_action {
    type                 = "forward"
    target_group_arn     = aws_lb_target_group.grafana-tg.arn
  }
}

# Creating Target Group
resource "aws_lb_target_group" "grafana-tg" {
  name             = "grafana-tg"
  port             = 31300
  protocol         = "HTTP"
  vpc_id           = var.vpc_id

  health_check {
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 5
    path                = "/login"
  }
}