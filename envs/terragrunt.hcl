locals {
  repo_root   = get_repo_root()
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  ecr_address = "${local.env_vars.locals.account_id}.dkr.ecr.${local.env_vars.locals.region}.amazonaws.com"
}

terraform {
  extra_arguments "parallelism" {
    commands = get_terraform_commands_that_need_parallelism()
    arguments = [
      "-parallelism=16"
    ]
  }
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = local.env_vars.locals.terraform_s3_bucket
    key            = "${basename(local.repo_root)}/${local.env_vars.locals.system_name}/${path_relative_to_include()}/terraform.tfstate"
    region         = local.env_vars.locals.region
    encrypt        = true
    dynamodb_table = local.env_vars.locals.terraform_dynamodb_table
  }
}

generate "version" {
  path      = "version_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = file(find_in_parent_folders("version.tf"))
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.env_vars.locals.region}"
  default_tags {
    tags = {
      SystemName = "${local.env_vars.locals.system_name}"
      EnvType    = "${local.env_vars.locals.env_type}"
    }
  }
}
EOF
}

catalog {
  urls = [
    "${local.repo_root}/modules/kms",
    "${local.repo_root}/modules/vpc",
    "${local.repo_root}/modules/subnets",
    "${local.repo_root}/modules/nat",
    "${local.repo_root}/modules/vpce",
    "${local.repo_root}/modules/ssm",
    "${local.repo_root}/modules/ec2"
  ]
}

inputs = {
  system_name                       = local.env_vars.locals.system_name
  env_type                          = local.env_vars.locals.env_type
  vpc_cidr_block                    = "10.0.0.0/16"
  enable_vpc_flow_log               = false
  cloudwatch_logs_retention_in_days = 14
  private_subnet_count              = 1
  public_subnet_count               = 1
  subnet_newbits                    = 8
  nat_gateway_count                 = 0
  vpc_interface_endpoint_services = [
    "ec2", "ec2messages", "ssm", "ssmmessages", "secretsmanager", "logs", "kms",
    # "ecr.dkr", "ecr.api", "ecs", "ecs-agent", "ecs-telemetry"
  ]
  create_ec2_instance  = true
  idle_session_timeout = 60
  instance_type        = "t4g.small"
  ebs_volume_size      = 32
  use_ssh              = false
  # image_id             = null
}
