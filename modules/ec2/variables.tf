variable "private_subnet_id" {
  description = "Private subnet ID"
  type        = string
}

variable "security_group_ids" {
  description = "Security group IDs"
  type        = list(string)
}

variable "kms_key_arn" {
  description = "KMS key ARN"
  type        = string
  default     = null
}

variable "ssm_session_document_name" {
  description = "SSM session document name"
  type        = string
  default     = null
}

variable "ssm_session_log_iam_policy_arn" {
  description = "SSM session log IAM policy ARN"
  type        = string
  default     = null
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

variable "image_id" {
  description = "EC2 AMI ID"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t4g.small"
}

variable "ebs_volume_size" {
  description = "EBS volume size"
  type        = number
  default     = 32
}

variable "create_ec2_instance" {
  description = "Create an EC2 instance"
  type        = bool
  default     = true
}
