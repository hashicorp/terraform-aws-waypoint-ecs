# Waypoint AWS ECS Terraform module

Terraform module which creates the infrastructure a single application needs 
to be deployed onto AWS ECS using Waypoint.

## About This Module

HashiCorp Waypoint is a tool that can be used to deploy web applications onto a wide variety
of platforms, including AWS ECS. 

Applications on AWS ECS require some _infrastructure_, e.g. resources that are not scoped
to an individual deployment, like a load balancer and security groups. While Waypoint can
create this infrastructure, it can also be created and sustainably managed through Terraform.

This module does not create infrastructure that is likely to be used by more than one
application, like a VPC or ECS Cluster. This kind of global infrastructure is required
as inputs to this module.

The module also takes some inputs that Waypoint will eventually require, but itself does not
need, like the AWS Cloudwatch Log Group name. These inputs are optional, and if specified,
the module will pass them along as outputs, so that Waypoint at runtime can read from a 
single TFC workspace.

For an end-to-end example of using this module, from creating a VPC to deploying an app
with Waypoint, see `examples/single-env`.

## Resources
This module creates the following resources:

- Elastic Container Registry (ECR) Repository (optional)
- Application Load Balancer (ALB)
- Security Group for the above ALB
- Security Group for the application's ECS tasks
- IAM role for the application's ECS tasks
- ECS Task Execution IAM role


## Usage

```hcl
provider "aws" {
  region = "<your AWS region>"
}
module "waypoint-ecs" {
  source = "hashicorp/terraform-aws-waypoint-ecs"

  # App-specific config
  waypoint_project = "webserver"
  application_port = 3000

  # Module config
  alb_internal = false
  create_ecr   = true
  
  # Uncomment below to enable deleting the registry even if there are images
  # force_delete_ecr = true

  # Existing infrastructure
  aws_region       = "us-east-1"
  vpc_id           = "vpc-055sampleve"
  public_subnets   = ["subnet-013examplesubnetd","subnet-096examplesubnet3"]
  private_subnets  = ["subnet-0e3c957example474","subnet-070f02dexample4a8"]
  ecs_cluster_name = "acmecorp_ecs_cluster"
  log_group_name   = "acmecorp_microservice_logs"

  tags = {
    company = "acmecorp"
  }
}

```

## License

This code is released under the Mozilla Public License 2.0. Please see [LICENSE](https://github.com/hashicorp/terraform-aws-waypoint-ecs/blob/master/LICENSE) for more details.
