data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_route53_zone" "current" {
  name = "${var.environment}.${var.apex_domain}"
}

data "aws_security_group" "alb" {
  name = "alb"
}

data "aws_lb" "alb" {
  name = var.environment
}

data "aws_lb_listener" "https" {
  load_balancer_arn = data.aws_lb.alb.arn
  port              = 443
}

data "aws_iam_policy_document" "ecs" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
