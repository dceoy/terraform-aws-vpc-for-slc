variable "system_name" {
  description = "System name"
  type        = string
}

variable "env_type" {
  description = "Environment type"
  type        = string
}

variable "create_io_s3_bucket" {
  description = "Whether to create an S3 bucket for IO"
  type        = bool
  default     = true
}

variable "create_awslogs_s3_bucket" {
  description = "Whether to create an AWS service logs S3 bucket"
  type        = bool
  default     = true
}

variable "create_s3logs_s3_bucket" {
  description = "Whether to create an S3 server access logs S3 bucket"
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "KMS key ARN"
  type        = string
  default     = null
}

variable "s3_expiration_days" {
  description = "Days to retain S3 objects"
  type        = number
  default     = null
}

variable "s3_force_destroy" {
  description = "Whether to delete all objects from the bucket when destroying the S3 bucket"
  type        = bool
  default     = true
}

variable "s3_noncurrent_version_expiration_days" {
  description = "Days to retain the noncurrent versions of S3 objects"
  type        = number
  default     = 7
  validation {
    condition     = var.s3_noncurrent_version_expiration_days >= 1
    error_message = "s3_noncurrent_version_expiration_days must be greater than or equal to 1"
  }
}

variable "s3_abort_incomplete_multipart_upload_days" {
  description = "Days to retain incomplete multipart uploads in S3"
  type        = number
  default     = 7
  validation {
    condition     = var.s3_abort_incomplete_multipart_upload_days >= 1
    error_message = "s3_abort_incomplete_multipart_upload_days must be greater than or equal to 1"
  }
}

variable "s3_expired_object_delete_marker" {
  description = "Whether to delete expired S3 object delete markers"
  type        = bool
  default     = true
}
