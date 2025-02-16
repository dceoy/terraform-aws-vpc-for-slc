variable "system_name" {
  description = "System name"
  type        = string
}

variable "env_type" {
  description = "Environment type"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
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

variable "vpc_cidr_blocks" {
  description = "CIDR blocks for VPC interface endpoint security group ingress"
  type        = list(string)
  default     = []
}
