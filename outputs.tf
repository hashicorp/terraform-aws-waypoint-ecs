output "ecr_repository_name" {
  value = local.ecs_repository_name
  description = "ecr registry name"
}

output "alb_arn" {
  value = aws_lb.alb.id
  description = "aws alb arn"
}

output "execution_role_name" {
  value = aws_iam_role.execution_role.name
  description = "aws ecs execution role name"
}

output "task_role_name" {
  value = aws_iam_role.task_role.name
  description = "aws ecs task role name"
}

output "security_group_id" {
  value = aws_security_group.app.id
  description = "security group for this project in particular"
}

# NOTE(izaak): it be possible for waypoint to source this data
# From these other workspaces directly, but abstracting that here allows
# each waypoint app to pull from one TFC workspace per waypoint workspace (environment).

output "private_subnets" {
  value = var.private_subnets
  description = "Private subnets should be used for the ecs task, and for internal ALBs"
}

output "public_subnets" {
  value = var.private_subnets
  description = "public subnets can optionally be used for internet-facing ALBs"
}

output "ecs_cluster_name" {
  value = var.ecs_cluster_name
  description = "todo"
}

output "log_group_name" {
  value = var.log_group_name
  description = "todo"
}

output "region" {
  value = var.aws_region
  description = "todo"
}


