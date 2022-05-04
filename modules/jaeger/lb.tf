resource "aws_lb_target_group" "jaeger" {
  name                 = var.name
  port                 = var.ui_port
  protocol             = "HTTP"
  target_type          = "ip"
  deregistration_delay = 5
  vpc_id               = var.vpc_id

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    path                = "/"
  }
}

resource "aws_route53_record" "jaeger" {
  zone_id = data.aws_route53_zone.current.zone_id
  name    = "jaeger.${data.aws_route53_zone.current.name}"
  type    = "A"

  alias {
    name                   = data.aws_lb.alb.dns_name
    zone_id                = data.aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_lb_listener_rule" "jaeger" {
  listener_arn = data.aws_lb_listener.https.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jaeger.arn
  }

  condition {
    host_header {
      values = [aws_route53_record.jaeger.name]
    }
  }
}