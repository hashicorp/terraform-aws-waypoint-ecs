
locals {
  ecs_repository_name = var.waypoint_project
}

module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  count = var.create_ecr ? 1 : 0

  repository_name         = local.ecs_repository_name
  repository_force_delete = var.force_delete_ecr
  create_lifecycle_policy = false

  tags = var.tags
}

