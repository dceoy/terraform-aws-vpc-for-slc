output "private_subnet_azs" {
  description = "Private subnet AZs"
  value       = aws_subnet.private[*].availability_zone
}

output "private_subnet_cidr_blocks" {
  description = "Private subnet CIDR blocks"
  value       = aws_subnet.private[*].cidr_block
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "private_route_table_ids" {
  description = "Private route table IDs"
  value       = aws_route_table.private[*].id
}

output "private_security_group_id" {
  description = "Private security group ID"
  value       = length(aws_security_group.private) > 0 ? aws_security_group.private[0].id : null
}

output "vpc_gateway_endpoint_ids" {
  description = "VPC gateway endpoint IDs"
  value       = { for k, v in aws_vpc_endpoint.gateway : k => v.id }
}

output "vpc_gateway_endpoint_cidr_blocks" {
  description = "VPC gateway endpoint CIDR blocks for the exposed AWS service"
  value       = { for k, v in aws_vpc_endpoint.gateway : k => v.cidr_blocks }
}

output "vpc_gateway_endpoint_prefix_list_ids" {
  description = "VPC gateway endpoint prefix list ID of the exposed AWS service"
  value       = { for k, v in aws_vpc_endpoint.gateway : k => v.prefix_list_id }
}

output "public_subnet_azs" {
  description = "Public subnet AZs"
  value       = aws_subnet.public[*].availability_zone
}

output "public_subnet_cidr_blocks" {
  description = "Public subnet CIDR blocks"
  value       = aws_subnet.public[*].cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "public_route_table_id" {
  description = "Public route table ID"
  value       = length(aws_route_table.public) > 0 ? aws_route_table.public[0].id : null
}

output "internet_gateway_id" {
  description = "Internet gateway ID"
  value       = length(aws_internet_gateway.public) > 0 ? aws_internet_gateway.public[0].id : null
}
