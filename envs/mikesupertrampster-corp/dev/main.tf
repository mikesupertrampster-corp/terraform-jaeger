provider "aws" {
  region = var.region

  assume_role {
    role_arn = "arn:aws:iam::${var.account_id}:role/${var.bootstrap_role}"
  }

  default_tags {
    tags = var.tags
  }
}

module "jaeger" {
  source      = "../../../modules//jaeger"
  vpc_id      = data.aws_vpc.current.id
  apex_domain = var.apex_domain
  environment = var.environment
  cluster_arn = data.aws_ecs_cluster.ecs.arn
  subnet_ids  = [for k, v in data.aws_subnet.subnet : v.id]
}