# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0


resource "aws_lb" "alb" {
  name               = local.waypoint_name
  internal           = var.alb_internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]

  subnets                    = var.alb_internal ? var.private_subnets : var.public_subnets
  enable_deletion_protection = false

  tags = local.tags
}