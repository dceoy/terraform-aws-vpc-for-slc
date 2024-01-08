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
  value       = aws_route_table.public.id
}

output "internet_gateway_id" {
  description = "Internet gateway ID"
  value       = aws_internet_gateway.public.id
}
