variable "system_name" {
  description = "System name"
  type        = string
}

variable "env_type" {
  description = "Environment type"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID"
  type        = string
}

variable "security_group_ids" {
  description = "Security group IDs"
  type        = list(string)
}

variable "iam_role_force_detach_policies" {
  description = "Whether to force detaching any IAM policies the IAM role has before destroying it"
  type        = bool
  default     = true
}

variable "create_ec2_instance" {
  description = "Whether to create an EC2 instance"
  type        = bool
  default     = true
}

variable "ssm_session_server_iam_policy_arn" {
  description = "SSM session server IAM policy ARN"
  type        = string
  default     = null
}

variable "ssm_session_client_iam_policy_arn" {
  description = "SSM session client IAM policy ARN"
  type        = string
  default     = null
}

variable "ec2_image_id" {
  description = "EC2 AMI ID"
  type        = string
  default     = null
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t4g.small"
}

variable "ec2_ebs_volume_size" {
  description = "EC2 EBS volume size"
  type        = number
  default     = 32
}

variable "use_ssh" {
  description = "Whether to use SSH for SSM session"
  type        = bool
  default     = true
}
