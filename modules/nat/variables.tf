variable "system_name" {
  description = "System name"
  type        = string
}

variable "env_type" {
  description = "Environment type"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs"
  type        = list(string)
}

variable "private_route_table_ids" {
  description = "Private route table IDs"
  type        = list(string)
}

variable "nat_gateway_count" {
  description = "NAT gateway count (regional mode: 0 to disable, 1 to enable)"
  type        = number
  default     = null
  validation {
    condition     = var.nat_gateway_count == null || contains([0, 1], var.nat_gateway_count)
    error_message = "NAT gateway count must be 0 or 1 in regional mode"
  }
}
