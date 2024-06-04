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

variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}\\/[0-9]{1,2}$", var.vpc_cidr_block))
    error_message = "VPC CIDR block must be a valid CIDR block"
  }
}

variable "vpc_secondary_cidr_blocks" {
  description = "VPC secondary CIDR blocks"
  type        = list(string)
  default     = []
  validation {
    condition     = alltrue([for c in var.vpc_secondary_cidr_blocks : can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}\\/[0-9]{1,2}$", c))])
    error_message = "VPC secondary CIDR blocks must be valid CIDR blocks"
  }
}

variable "vpc_flow_log_s3_bucket_id" {
  description = "VPC flow log S3 IAM policy ARN"
  type        = string
  default     = null
}

variable "vpc_s3_key_prefix" {
  description = "VPC S3 key prefix"
  type        = string
  default     = "vpc"
}

variable "kms_key_arn" {
  description = "KMS key ARN"
  type        = string
  default     = null
}
