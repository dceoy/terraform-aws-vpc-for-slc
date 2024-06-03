variable "system_name" {
  description = "System name"
  type        = string
  default     = "dbl"
}

variable "env_type" {
  description = "Environment type"
  type        = string
  default     = "dev"
}

variable "create_log_s3_bucket" {
  description = "Create a log S3 bucket"
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "KMS key ARN"
  type        = string
  default     = null
}

variable "s3_expiration_days" {
  description = "S3 expiration days"
  type        = number
  default     = null
}

variable "s3_force_destroy" {
  description = "S3 force destroy"
  type        = bool
  default     = true
}

variable "s3_noncurrent_version_expiration_days" {
  description = "S3 noncurrent version expiration days"
  type        = number
  default     = 7
}

variable "s3_abort_incomplete_multipart_upload_days" {
  description = "S3 abort incomplete multipart upload days"
  type        = number
  default     = 7
}
