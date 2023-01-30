
### App-specific config

variable "application_port" {
  description = "Port on which the application will be listening"
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
    Whether or not the created an ECR repository.
    Generally, apps have one ECR repository for images,
    and all environments pull from that same repository. When using
    this module to create multiple environments (e.g. multiple
    workspaces), only one environment should create the registry.
  EOF
  type = bool
  default = true
}

### Infrastructure Connections

variable "aws_region" {
  description = ""
  type        = string
}

variable "vpc_id" {
  description = "todo"
  type = string
}

variable "public_subnets" {
  description = "todo"
  type = list(string)
}

variable "private_subnets" {
  description = "todo"
  type = list(string)
}

variable "ecs_cluster_name" {
  description = "todo"
  type = string
}

variable "log_group_name" {
  description = "todo"
  type = string
}

### Infrastructure Config

variable "alb_port" {
  description = "Port on which the load balancer should listen"
  type = number
  default = 80
}

variable "tags" {
  description = "Tags to apply to resources created by this module."
  type        = map(string)
  default     = {}
}