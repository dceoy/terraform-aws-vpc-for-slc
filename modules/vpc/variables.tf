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

variable "enable_vpc_flow_log" {
  description = "Enable VPC flow log"
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "KMS key ARN"
  type        = string
  default     = null
}

variable "cloudwatch_logs_retention_in_days" {
  description = "CloudWatch Logs retention in days"
  type        = number
  default     = 30
  validation {
    condition     = var.cloudwatch_logs_retention_in_days == null ? true : contains([0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.cloudwatch_logs_retention_in_days)
    error_message = "Must be 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653 or 0 (zero indicates never expire logs)."
  }
}
