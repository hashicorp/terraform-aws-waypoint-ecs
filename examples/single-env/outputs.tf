# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# NOTE: For convenience, all outputs from the module are exported as a single object.
# It would also be possible to declare each output individually, but Waypoint will
# likely need them all.

output "waypoint-ecs" {
  value = module.waypoint-ecs
  description = "All outputs from the waypoint ecs terraform module."
}

