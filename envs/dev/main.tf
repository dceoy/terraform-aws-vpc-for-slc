module "vpc" {
  source         = "../../modules/vpc"
  project_name   = var.project_name
  env_type       = var.env_type
  vpc_cidr_block = var.vpc_cidr_block
}

module "subnet" {
  source               = "../../modules/subnet"
  vpc_id               = module.vpc.vpc_id
  project_name         = var.project_name
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
  project_name            = var.project_name
  env_type                = var.env_type
}

module "vpce" {
  source             = "../../modules/vpce"
  count              = var.create_vpc_interface_endpoints && var.private_subnet_count > 0 ? 1 : 0
  private_subnet_ids = module.subnet.private_subnet_ids
  security_group_ids = [module.vpc.vpc_default_security_group_id]
  project_name       = var.project_name
  env_type           = var.env_type
}

module "ec2" {
  source             = "../../modules/ec2"
  count              = var.create_ec2_instance && var.private_subnet_count > 0 ? 1 : 0
  private_subnet_id  = module.subnet.private_subnet_ids[0]
  security_group_ids = [module.vpc.vpc_default_security_group_id]
  project_name       = var.project_name
  env_type           = var.env_type
  image_id           = var.image_id
  instance_type      = var.instance_type
  ebs_volume_size    = var.ebs_volume_size
}
