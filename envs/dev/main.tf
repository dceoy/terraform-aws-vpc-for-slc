module "vpc" {
  source              = "../../modules/vpc"
  system_name         = var.system_name
  env_type            = var.env_type
  vpc_cidr_block      = var.vpc_cidr_block
  enable_vpc_flow_log = var.enable_vpc_flow_log
}

module "subnet" {
  source               = "../../modules/subnet"
  vpc_id               = module.vpc.vpc_id
  system_name          = var.system_name
  env_type             = var.env_type
  private_subnet_count = var.private_subnet_count
  public_subnet_count  = var.public_subnet_count
  subnet_newbits       = var.subnet_newbits
}

module "nat" {
  source                  = "../../modules/nat"
  count                   = var.create_nat_gateways && var.public_subnet_count > 0 && var.private_subnet_count > 0 ? 1 : 0
  public_subnet_ids       = module.subnet.public_subnet_ids
  private_route_table_ids = module.subnet.private_route_table_ids
  system_name             = var.system_name
  env_type                = var.env_type
}

module "vpce" {
  source             = "../../modules/vpce"
  count              = var.create_vpc_interface_endpoints && var.private_subnet_count > 0 ? 1 : 0
  private_subnet_ids = module.subnet.private_subnet_ids
  security_group_ids = [module.subnet.private_security_group_id]
  system_name        = var.system_name
  env_type           = var.env_type
}

module "ssm" {
  source               = "../../modules/ssm"
  count                = var.create_ec2_instance && var.private_subnet_count > 0 && !var.use_ssh ? 1 : 0
  system_name          = var.system_name
  env_type             = var.env_type
  idle_session_timeout = var.idle_session_timeout
}

module "ec2" {
  source                         = "../../modules/ec2"
  count                          = var.create_ec2_instance && var.private_subnet_count > 0 ? 1 : 0
  private_subnet_id              = module.subnet.private_subnet_ids[count.index]
  security_group_ids             = [module.subnet.private_security_group_id]
  ssm_session_document_name      = length(module.ssm) > 0 ? module.ssm[0].ssm_session_document_name : null
  ssm_session_kms_key_arn        = length(module.ssm) > 0 ? module.ssm[0].ssm_session_kms_key_arn : null
  ssm_session_log_iam_policy_arn = length(module.ssm) > 0 ? module.ssm[0].ssm_session_log_iam_policy_arn : null
  system_name                    = var.system_name
  env_type                       = var.env_type
  image_id                       = var.image_id
  instance_type                  = var.instance_type
  ebs_volume_size                = var.ebs_volume_size
}
