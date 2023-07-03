# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# This infrastructure is required

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.18"

  name = local.name
  cidr = "172.16.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
  private_subnets = ["172.16.0.0/20", "172.16.16.0/20", "172.16.32.0/20", "172.16.48.0/20", "172.16.64.0/20"]
  public_subnets  = ["172.16.80.0/20", "172.16.96.0/20", "172.16.112.0/20", "172.16.128.0/20", "172.16.144.0/20"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.tags
}

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 4.1"

  cluster_name = local.name
  tags         = local.tags
}

resource "aws_cloudwatch_log_group" "services" {
  name = "ecs_cluster_${local.name}"
  tags = local.tags
  retention_in_days = 7
}