# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "aws_security_group" "app" {
  name        = "${local.waypoint_name}_internal"
  description = "Security group for waypoint project ${var.waypoint_project}"
  vpc_id      = var.vpc_id

  # Allow egress to anything
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # Allow ingress from ALB. App serves non-tls inside the VPC.
  ingress {
    description     = "internal [[traffic"
    from_port       = var.application_port
    to_port         = var.application_port
    protocol        = "tcp"
    security_groups = [aws_security_group.lb.id]
  }

  tags = local.tags
}

resource "aws_security_group" "lb" {
  name        = "${local.waypoint_name}_external"
  description = "Allow all external traffic and designed to be attached to the ALB"
  vpc_id      = var.vpc_id

  # Egress managed by external rule to avoid circular dependency

  ingress {
    description      = "internal traffic"
    from_port        = var.alb_port
    to_port          = var.alb_port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = local.tags
}

resource "aws_security_group_rule" "external_egress" {
  type                     = "egress"
  from_port                = var.application_port
  to_port                  = var.application_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.app.id
  security_group_id        = aws_security_group.lb.id
}