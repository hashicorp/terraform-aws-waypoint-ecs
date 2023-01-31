project = "sampleapp-tfc-ecs-1"

app "sampleapp-tfc-ecs-1" {

  build {
    use "pack" {}

    registry {
      use "aws-ecr" {
        region     = var.tfc_infra.waypoint-ecs.region
        repository = var.tfc_infra.waypoint-ecs.ecr_repository_name
        tag        = gitrefpretty()
      }
    }
  }

  deploy {

    # Default workspace deploys to dev
    use "aws-ecs" {
      count = 1
      memory = 512
      cpu = 256
      service_port = 3000
      assign_public_ip = false
      logging {
        create_group = false
      }

      cluster             = var.tfc_infra.waypoint-ecs.ecs_cluster_name
      log_group           = var.tfc_infra.waypoint-ecs.log_group_name
      execution_role_name = var.tfc_infra.waypoint-ecs.execution_role_name
      task_role_name      = var.tfc_infra.waypoint-ecs.task_role_name
      region              = var.tfc_infra.waypoint-ecs.region
      subnets             = var.tfc_infra.waypoint-ecs.private_subnets
      security_group_ids  = [var.tfc_infra.waypoint-ecs.security_group_id]
      alb {
        load_balancer_arn = var.tfc_infra.waypoint-ecs.alb_arn
      }
    }
  }
}

## Dev
variable "tfc_infra" {
  default = dynamic("terraform-cloud", {
    organization = "<YOUR_TFC_ORGANIZATION_HERE>"
    workspace    = "sampleapp-tfc-ecs-1"
  })
  type        = any
  sensitive   = false
  description = "all outputs from this app's tfc workspace"
}