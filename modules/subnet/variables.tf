variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

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

variable "private_subnet_count" {
  description = "Number of private subnets"
  type        = number
  default     = 3
}

variable "public_subnet_count" {
  description = "Number of public subnets"
  type        = number
  default     = 3
}

variable "subnet_newbits" {
  description = "New bits for a subnet"
  type        = number
  default     = 8
}
