variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "system_name" {
  description = "System name"
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
  validation {
    condition     = var.private_subnet_count >= 0 && var.private_subnet_count <= 3
    error_message = "Private subnet count must be between 0 and 3"
  }
}

variable "public_subnet_count" {
  description = "Number of public subnets"
  type        = number
  default     = 3
  validation {
    condition     = var.public_subnet_count >= 0 && var.public_subnet_count <= 3
    error_message = "Public subnet count must be between 0 and 3"
  }
}

variable "subnet_newbits" {
  description = "New bits for a subnet"
  type        = number
  default     = 8
  validation {
    condition     = var.subnet_newbits > 0
    error_message = "Subnet newbits must be greater than 0"
  }
}
