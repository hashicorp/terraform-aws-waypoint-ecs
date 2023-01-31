
provider "aws" {
  region = local.region
}

locals {
  region = "us-east-1"
  name   = "tf_wp_ecs_ex_single_env"

  tags = {
    Name       = local.name
    Example    = local.name
    Repository = "https://github.com/hashicorp/terraform-aws-waypoint-ecs"
  }
}

################################################################################
# Terraform Cloud Config.
# Required for Waypoint to read outputs from this workspace at deploy time
# If omitted, outputs from this terraform run must be directly copied into
# the waypoint.hcl.
################################################################################

terraform {
  cloud {
    organization = "<YOUR_TFC_ORGANIZATION_HERE>"

    # TODO(izaak): remove below before publication
    #organization = "izaaktest"

    workspaces {
      name = "sampleapp-tfc-ecs-1"
    }
  }
}

################################################################################
# terraform-aws-waypoint-ecs module
################################################################################

module "waypoint-ecs" {
  source = "../.."

  # App-specific config
  waypoint_project = "sampleapp-tfc-ecs-1"
  application_port = 3000

  # Module config
  alb_internal = false
  create_ecr   = true

  # Existing infrastructure
  aws_region       = local.region
  vpc_id           = module.vpc.vpc_id
  public_subnets   = module.vpc.public_subnets
  private_subnets  = module.vpc.private_subnets
  ecs_cluster_name = module.ecs.cluster_name
  log_group_name   = aws_cloudwatch_log_group.services.name

  tags = local.tags
}



