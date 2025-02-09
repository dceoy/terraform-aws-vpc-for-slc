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

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs"
  type        = list(string)
}

variable "vpc_interface_endpoint_services" {
  description = "VPC interface endpoint services"
  type        = list(string)
  default = [
    "ec2",
    "ec2messages",
    "ssm",
    "ssmmessages",
    "secretsmanager",
    "ecr.dkr",
    "ecr.api",
    "ecs",
    "ecs-agent",
    "ecs-telemetry",
    "logs",
    "kms"
  ]
}
