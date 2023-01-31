# Single-Environment ECS Waypoint Application

This example shows how to set up the infrastructure necessary to deploy a webserver application onto
AWS ECS using Waypoint.

The example creates baseline global infrastructure directly, including a VPC and ECS cluster, then uses
this `terraform-aws-waypoint-ecs` module to create the application-specific infrastructure.

It also includes a sample nodejs webserver app in the `sampleapp-tfc-ecs-1` directory, along with a
`waypoint.hcl` file that can read the infrastructure outputs from a Terraform Cloud Workspace that has
run this module.

<!-- TODO: when we have a multi-env example, link to that here -->
<!-- TODO: link to a more complete learn guide - this example alone is pretty sparse on the exact procedure -->

Configuration in this directory creates:

### Application Infrastructure
This infrastructure is likely to be used by a single application, and is
created by the `terraform-aws-waypoint-ecs` module. See `main.tf`

- An Elastic Container Registry (ECR) Repository
- An Application Load Balancer (ALB)
- A Security Group for the above ALB
- A Security Group for the application's ECS tasks
- An IAM role for the application's ECS tasks
- An ECS Task Execution IAM role

### Shared Infrastructure

This infrastructure is required to deploy an application onto ECS with Waypoint,
but can be used by many applications. See `shared_infrastructure.tf`

- A VPC in us-east-1
- An ECS cluster
- An AWS CloudWatch Log Group

## Requirements

### Terraform requirements
| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.6 |

### Terraform Cloud

The sample waypoint.hcl in `sampleapp-tfc-ecs-1` uses the Waypoint [Terraform ConfigSourcer](https://developer.hashicorp.com/waypoint/plugins/terraform-cloud#terraform-cloud-configsourcer),
which reads from a Terraform Cloud workspace. While this module can be run using Terraform locally, we recommend
connecting it to a Terraform Cloud workspace.

A search of this example directory for `<YOUR_TFC_ORGANIZATION_HERE>` will show where your TFC org needs to be substituted.

For more details, see [Terraform Cloud Getting Started](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started)

### Waypoint

After creating the infrastructure using this example, you can deploy the `sampleapp-tfc-ecs-1` nodejs webserver application
onto the infrastructure using Waypoint. For this, you'll need:

#### Waypoint Server

You'll need a [Waypoint server](https://developer.hashicorp.com/waypoint/docs/server). For the easiest getting started experience, 
choose [HCP Waypoint](https://cloud.hashicorp.com/products/waypoint).

You'll need the [Waypoint CLI](https://developer.hashicorp.com/waypoint/downloads) installed, and a local
[context](https://developer.hashicorp.com/waypoint/commands/context) pointing to your server.

#### Waypoint Runner

You'll need a remote [runner](https://developer.hashicorp.com/waypoint/docs/runner). The most convenient option is to
install a remote runner into the ECS cluster created as part of this example. After running this module to create
your cluster, ensure you have local authorization to AWS (e.g. local 
[AWS environment variables](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html) set), and
then run a `waypoint runner install` command.

The below command assumes you're using the HCP waypoint server

```shell
waypoint runner install \
  -platform=ecs \
  -server-addr=api.hashicorp.cloud:443 \
  -ecs-runner-image=hashicorp/waypoint:latest \
  -ecs-cluster=tf_wp_ecs_ex_single_env \
  -ecs-region=us-east-1
```

This will configure a waypoint runner in the `tf_wp_ecs_ex_single_env` ECS cluster, and configure a default 
[runner profile](https://developer.hashicorp.com/waypoint/docs/runner/profiles) for launching
[on-demand runners](https://developer.hashicorp.com/waypoint/docs/runner/on-demand-runner) inside that same
cluster to do the work of building, deploying, and releasing.

#### Waypoint ConfigSourcer

Your Waypoint runners will need to be able to talk to Terraform Cloud to read outputs from this module. This is
accomplished by setting a Waypoint [ConfigSourcer](https://developer.hashicorp.com/waypoint/plugins/terraform-cloud#terraform-cloud-configsourcer).

Create a [TFC API token](https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/api-tokens) for
Waypoint, and then run the following command:

```shell
waypoint config source-set -type=terraform-cloud -config=token=<YOUR_TFC_API_TOKEN>
```

## Deploying with Waypoint

Once all the Waypoint prerequisites are met, and this Terraform has been run in a Terraform Cloud workspace, you can
deploy the sample nodejs webserver into you cluster with Waypoint.

To be able to build your code and read the `waypoint.hcl` file, Waypoint needs your project to have a git repo. We
recommend that you create a new git repository, and copy the contents of `sampleapp-tfc-ecs-1` into it. 

Edit the `waypoint.hcl` to replace `<YOUR_TFC_ORGANIZATION_HERE>` with the name of your TFC org, and then commit
and push your changes.

If using HCP Waypoint, visit the [HCP Portal](https://portal.cloud.hashicorp.com/), click the Waypoint sub-tab on 
the left, and then Create Project. From there, you can connect your project to your github repo using the 
Waypoint Github App.

Once complete, you can locally run `waypoint up` to build, deploy, and release the app onto your ECS cluster.

```shell

```


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.6 |

## Modules

| Name                                                                             | Source                                   | Version |
|----------------------------------------------------------------------------------|------------------------------------------|---------|
| <a name="module_aws_waypoint_ecs"></a> [aws_waypoint_ecs](#module\_aws_waypoint_ecs)  | ../../                                   | n/a     |
| <a name="module_ecs"></a> [ecs](#module\_ecs)                                    | terraform-aws-modules/terraform-aws-ecs  | ~> 4.1  |
| <a name="module_vpc"></a> [vpc](#module\_vpc)                                    | terraform-aws-modules/vpc/aws            | ~> 3.18 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |

## Inputs

No inputs.

## Outputs

| Name                                                                | Description                                                   |
|---------------------------------------------------------------------|---------------------------------------------------------------|
| <a name="waypoint_ecs"></a> [waypoint\_ecs](#output\_waypoint\_ecs) | Map of all outputs from the terraform_aws_waypoint_ecs module |