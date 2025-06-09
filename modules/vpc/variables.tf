variable "system_name" {
  description = "System name"
  type        = string
}

variable "env_type" {
  description = "Environment type"
  type        = string
}

variable "cloudwatch_logs_retention_in_days" {
  description = "CloudWatch Logs retention in days"
  type        = number
  default     = 30
  validation {
    condition     = contains([0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.cloudwatch_logs_retention_in_days)
    error_message = "CloudWatch Logs retention in days must be 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653 or 0 (zero indicates never expire logs)"
  }
}

variable "kms_key_arn" {
  description = "KMS key ARN"
  type        = string
  default     = null
}

variable "iam_role_force_detach_policies" {
  description = "Whether to force detaching any IAM policies the IAM role has before destroying it"
  type        = bool
  default     = true
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

variable "vpc_assign_generated_ipv6_cidr_block" {
  description = "Whether to assign a generated IPv6 CIDR block to the VPC"
  type        = bool
  default     = false
}

variable "vpc_flow_log_s3_bucket_id" {
  description = "VPC flow log S3 bucket ID"
  type        = string
  default     = null
}

variable "vpc_flow_log_s3_key_prefix" {
  description = "S3 key prefix for VPC flow logs"
  type        = string
  default     = "vpc"
}

variable "vpc_flow_log_traffic_type" {
  description = "Type of traffic to capture in VPC flow logs"
  type        = string
  default     = "ALL"
  validation {
    condition     = contains(["ACCEPT", "REJECT", "ALL"], var.vpc_flow_log_traffic_type)
    error_message = "Flow logs traffic type must be either ACCEPT, REJECT, or ALL"
  }
}

variable "vpc_flow_log_max_aggregation_interval" {
  description = "The maximum interval of time during which a flow of packets is captured and aggregated into a VPC flow log record"
  type        = number
  default     = 600
  validation {
    condition     = contains([60, 600], var.vpc_flow_log_max_aggregation_interval)
    error_message = "Flow logs max aggregation interval must be either 60 seconds (1 minute) or 600 seconds (10 minutes)"
  }
}

variable "create_vpc_flow_log_group" {
  description = "Whether to create a CloudWatch log group for VPC flow logs"
  type        = bool
  default     = false
}
