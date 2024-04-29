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

variable "idle_session_timeout" {
  description = "Idle session timeout"
  type        = number
  default     = 60
}

variable "kms_key_arn" {
  description = "KMS key ARN"
  type        = string
  default     = null
}

variable "cloudwatch_logs_retention_in_days" {
  description = "CloudWatch Logs retention in days"
  type        = number
  default     = 14
  validation {
    condition     = var.cloudwatch_logs_retention_in_days >= 1 && var.cloudwatch_logs_retention_in_days <= 3653
    error_message = "CloudWatch Logs retention in days must be between 1 and 3653"
  }
}
