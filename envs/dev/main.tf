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
