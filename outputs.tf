
# Outputs required by the Waypoint ECS Plugin

### Resources created by this module
output "ecr_repository_name" {
  value       = local.ecs_repository_name
  description = "Name of the ECR registry for this application. Note: "
}

output "alb_arn" {
  value       = aws_lb.alb.id
  description = "Arn of the AWS ALB that will serve traffic for the application."
}

output "execution_role_name" {
  value       = aws_iam_role.execution_role.name
  description = "The name of the IAM role to use for ECS execution."
}

output "task_role_name" {
  value       = aws_iam_role.task_role.name
  description = "The name of the IAM role to assign to the application's ECS tasks."
}

output "security_group_id" {
  value       = aws_security_group.app.id
  description = "ID of the security group intended for use by ECS tasks"
}

output "private_subnets" {
  value       = var.private_subnets
  description = <<EOF
    List of private subnet IDs to assign the the ENIs of ECS tasks.
    Same as input variable private_subnets.
  EOF
}

output "public_subnets" {
  value       = var.public_subnets
  description = "List of public subnets ids, same as variable public_subnets."
}

output "ecs_cluster_name" {
  value       = var.ecs_cluster_name
  description = "Name of the ecs cluster that the application should be deployed into."
}

output "log_group_name" {
  value       = var.log_group_name
  description = "Name of the AWS CloudWatch log group for this application to submit logs to."
}

output "region" {
  value       = var.aws_region
  description = "AWS region for the application to deploy into, e.g. 'us-east-1'."
}

### Other outputs, useful for configuring the infrastructure with additional terraform

output "alb_security_group_id" {
  value       = aws_security_group.lb.id
  description = <<EOF
    ID of the security group created for the ALB.
    This module will not create , but it will output this
    name for the Waypoint ECS Platform plugin to consume.
  EOF
}


