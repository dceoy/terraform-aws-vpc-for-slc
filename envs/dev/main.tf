module "vpc" {
  source               = "../../modules/vpc"
  project_name         = var.project_name
  env_type             = var.env_type
  vpc_cidr             = var.vpc_cidr
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
}
