terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.6"
    }
  }
}

locals {
  # Full waypoint name, including the workspace if provided.
  # E.g. "hashicups_prod", or just "hashicups" if no workspace
  waypoint_name = var.waypoint_workspace != null ? "${var.waypoint_project}-${var.waypoint_workspace}" : var.waypoint_project

  tags = merge(var.tags, {
      terraform          = "true"
      waypoint           = "true"
      waypoint_project   = var.waypoint_project
      waypoint_workspace = var.waypoint_workspace
    }
  )
}