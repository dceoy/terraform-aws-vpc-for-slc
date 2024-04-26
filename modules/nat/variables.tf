variable "public_subnet_ids" {
  description = "Public subnet IDs"
  type        = list(string)
}

variable "private_route_table_ids" {
  description = "Private route table IDs"
  type        = list(string)
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

variable "nat_gateway_count" {
  description = "NAT gateway count"
  type        = number
  default     = null
  validation {
    condition     = var.nat_gateway_count == null || var.nat_gateway_count >= 0
    error_message = "NAT gateway count must be greater than or equal to 0"
  }
}
