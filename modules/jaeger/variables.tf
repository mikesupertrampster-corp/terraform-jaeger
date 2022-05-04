variable "apex_domain" {
  type = string
}

variable "cluster_arn" {
  type = string
}

variable "environment" {
  type = string
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "name" {
  type    = string
  default = "jaeger"
}

variable "subnet_ids" {
  type = list(string)
}

variable "jaeger_image" {
  type    = string
  default = "jaegertracing/all-in-one:1.33"
}

variable "ui_port" {
  type    = number
  default = 16686
}

variable "vpc_id" {
  type = string
}
