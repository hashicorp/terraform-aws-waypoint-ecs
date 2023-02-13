# sampleapp-tfc-ecs-1

Copied from waypoint-examples aws/aws-ecs/nodejs

|Title|Description|
|---|---|
|Pack|Cloud Native Buildpack|
|Cloud|AWS|
|Language|NodeJS|
|Docs|[AWS-ECS](https://www.waypointproject.io/plugins/aws-ecs)|
|Tutorial|[HashiCorp Learn](https://learn.hashicorp.com/tutorials/waypoint/aws-ecs)|

This example demonstrates the AWS Elastic Container Service `deploy` plugin
which also provides a `build` step for the Elastic Container Registry.

This uses the Terraform ConfigSourcer to source data from a Terraform Cloud workspace 
that runs and outputs values from the terraform-aws-waypoint-ecs module.

Terraform Cloud is optional - you can copy the values from the output of the
terraform-aws-waypoint-ecs module directly into the waypoint.hcl instead.
