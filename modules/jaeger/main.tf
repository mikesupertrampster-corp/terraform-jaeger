locals {
  ports = {
    udp = [5775, 6831, 6832]
    tcp = [5778, var.ui_port, 14250, 14268, 14269, 9411]
  }
}

resource "aws_cloudwatch_log_group" "jaeger" {
  name              = "/ecs/${var.name}"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "jaeger" {
  family                   = var.name
  execution_role_arn       = aws_iam_role.execution.arn
  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  task_role_arn            = aws_iam_role.jaeger.arn

  runtime_platform {
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name       = "jaeger"
      image      = var.jaeger_image
      cpu        = 0
      essential  = true
      privileged = false

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.jaeger.name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs"
        }
      }

      portMappings = flatten([
        for protocol, ports in local.ports : [
          for port in ports : {
            containerPort = port
            hostPort      = port
            protocol      = protocol
          }
        ]
      ])

      environment = [
        {
          name  = "COLLECTOR_ZIPKIN_HOST_PORT",
          value = "9411",
        }
      ]
    }
  ])
}

resource "aws_security_group" "jaeger" {
  name   = var.name
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.jaeger.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"
}

resource "aws_security_group_rule" "ingress" {
  security_group_id        = aws_security_group.jaeger.id
  from_port                = var.ui_port
  to_port                  = var.ui_port
  protocol                 = "tcp"
  source_security_group_id = data.aws_security_group.alb.id
  type                     = "ingress"
}

resource "aws_ecs_service" "jaeger" {
  name                    = var.name
  cluster                 = var.cluster_arn
  task_definition         = aws_ecs_task_definition.jaeger.arn
  desired_count           = var.desired_count
  enable_ecs_managed_tags = true

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    base              = 0
    weight            = 1
  }

  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.jaeger.id]
    subnets          = var.subnet_ids
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.jaeger.arn
    container_name   = "jaeger"
    container_port   = var.ui_port
  }
}