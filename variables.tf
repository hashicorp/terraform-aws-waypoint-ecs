
### App-specific config

variable "application_port" {
  description = "Port on which the application will be listening."
  type = number
}

### Waypoint config

variable "waypoint_project" {
  description = "Name of the waypoint project, to be used in all resource names."
  type        = string
}

variable "waypoint_workspace" {
  description = "Name of the waypoint workspace. If set, this workspace name will be included in resource names."
  type        = string
  default     = null
}

# NOTE: Application name is intentionally omitted as an input source. If you have multiple apps in the same project
# that all use aws ecs, you can use this module as a reference to see which resources are at play, decide which
# resources your apps should own exclusively or share, and then build terraform similar to this module.

### Environment-specific config

variable "alb_internal" {
  description = <<EOF
    Whether or not the created ALB should be internal.
    If set, the created ALB will have a scheme of internal,
    otherwise by default it has a scheme of internet-facing.
  EOF
  type = bool
  default = false
}

variable "create_ecr" {
  description = <<EOF
    Controls if an ECR repository should be created.
    Generally, apps have one ECR repository for images,
    and all environments pull from that same repository. When using
    this module to create multiple environments (e.g. multiple
    workspaces), only one environment should create the registry.
  EOF
  type = bool
  default = true
}

### Infrastructure Config

variable "alb_port" {
  description = "Port on which the load balancer should listen."
  type = number
  default = 80
}

variable "tags" {
  description = "Tags to apply to resources created by this module."
  type        = map(string)
  default     = {}
}

### Required Infrastructure connections, necessary for this module to create it's resources.

variable "vpc_id" {
  description = <<EOF
    ID of the VPC for the application to deploy into.
    Application and load balancer security groups will be created in this VPC.
  EOF
  type = string
}

variable "private_subnets" {
  description = <<EOF
    List of private subnet IDs to assign the the ENIs of ECS tasks, and internal ALBs.
    Only required if alb_internal is true, or if you wish to rely on this module's
    private_subnets output.
  EOF
  type = list(string)
}

variable "public_subnets" {
  description = <<EOF
    List of public subnet IDs to assign to internet-facing ALB for this application.
    Only required if alb_internal is false, or if wish to rely on this module's
    public_subnets output.
  EOF
  type = list(string)
}


### Optional infrastructure connections. The Waypoint ECS plugins will need these
### values, and it's convenient for the plugin to source from only one TFC workspace.
### It's also possible to source these in the waypoint.hcl from other workspaces,
### or define them statically.

variable "aws_region" {
  description = <<EOF
    Optional: AWS region for the application to deploy into, e.g. 'us-east-1'.

    If blank, the region output will also be blank.
  EOF
  type        = string
}

variable "ecs_cluster_name" {
  description = <<EOF
    Optional: Name of the ecs cluster that the application should be deployed into.
    This module will not create an ECS cluster, but it will output this
    name for the Waypoint ECS Platform plugin to consume.

    If blank, the ecs_cluster_name output will also be blank.
  EOF
  type = string
}

variable "log_group_name" {
  description = <<EOF
    Optional: Name of the AWS CloudWatch log group for this application to submit logs to.
    This module will not create an ECS cluster, but it will output this
    name for the Waypoint ECS Platform plugin to consume.

    If blank, the log_group_name output will also be blank.
  EOF
  type = string
}