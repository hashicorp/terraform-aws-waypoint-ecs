# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# iam roles

resource "aws_iam_role" "execution_role" {
  name = "${local.waypoint_name}_ecs_execution"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags

  inline_policy {}
}

# Future improvement: use a custom execution role policy that allows pulling only from
# this app's ECR repository

resource "aws_iam_role_policy_attachment" "execution_role" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "task_role" {
  name = "${local.waypoint_name}_ecs_task"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags

  inline_policy {}
}

data "aws_iam_policy" "custom_task_role_policies" {
  count    = length(var.task_role_custom_policy_arns)
  arn      = var.task_role_custom_policy_arns[count.index]
}

resource "aws_iam_role_policy_attachment" "custom_task_role_policies" {
  for_each = {
    for policy in data.aws_iam_policy.custom_task_role_policies : policy.name => policy
  }
  role       = aws_iam_role.task_role.name
  policy_arn = each.value.arn
}

# Future improvement: add policy to waypoint runner role to allow registry push

