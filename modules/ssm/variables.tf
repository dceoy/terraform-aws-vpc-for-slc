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

variable "create_ssm_session_document" {
  description = "Create a SSM session document"
  type        = bool
  default     = true
}

variable "ssm_session_idle_session_timeout" {
  description = "SSM session idle session timeout in minutes"
  type        = number
  default     = 60
}

variable "ssm_session_log_s3_bucket_id" {
  description = "SSM session log S3 IAM policy ARN"
  type        = string
  default     = null
}

variable "ssm_s3_key_prefix" {
  description = "SSM S3 key prefix"
  type        = string
  default     = "ssm"
}

variable "kms_key_arn" {
  description = "KMS key ARN"
  type        = string
  default     = null
}
