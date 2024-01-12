variable "ec2_instance_role_arn" {
  description = "EC2 instance role ARN"
  type        = string
}

variable "project_name" {
  description = "Set the project name."
  type        = string
  default     = "slc"
}

variable "env_type" {
  description = "Environment type"
  type        = string
  default     = "dev"
}
