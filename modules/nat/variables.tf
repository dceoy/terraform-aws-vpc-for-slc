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

variable "private_route_table_ids" {
  description = "Private route table IDs"
  type        = list(string)
}

variable "create_nat_gateway" {
  description = "Whether to create a regional NAT gateway"
  type        = bool
  default     = false
}
