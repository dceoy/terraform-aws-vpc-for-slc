variable "project_name" {
  description = "Project name"
  type        = string
  default     = "slc"
}

variable "env_type" {
  description = "Environment type"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.16.0/24", "10.0.32.0/24"]
}

module "vpc" {
  source               = "../../modules/vpc"
  project_name         = var.project_name
  env_type             = var.env_type
  vpc_cidr             = var.vpc_cidr
  private_subnet_cidrs = var.private_subnet_cidrs
}
