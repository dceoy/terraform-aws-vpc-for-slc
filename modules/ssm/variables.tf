variable "system_name" {
  description = "System name"
  type        = string
}

variable "env_type" {
  description = "Environment type"
  type        = string
}

variable "create_ssm_session_document" {
  description = "Whether to create an SSM session document"
  type        = bool
  default     = true
}

variable "ssm_session_idle_session_timeout" {
  description = "SSM session idle session timeout in minutes"
  type        = number
  default     = 60
}

variable "ssm_session_ssh_port_number" {
  description = "SSM session SSH port number"
  type        = number
  default     = 22
}

variable "ssm_logs_s3_bucket_id" {
  description = "SSM session logs S3 bucket ID"
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
