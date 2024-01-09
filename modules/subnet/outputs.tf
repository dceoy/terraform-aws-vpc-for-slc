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

output "s3_gateway_endpoint" {
  description = "S3 gateway endpoint"
  value       = length(aws_vpc_endpoint.s3_gateway) > 0 ? aws_vpc_endpoint.s3_gateway[0].id : null
}

output "dynamodb_gateway_endpoint" {
  description = "DynamoDB gateway endpoint"
  value       = length(aws_vpc_endpoint.dynamodb_gateway) > 0 ? aws_vpc_endpoint.dynamodb_gateway[0].id : null
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

output "public_route_table_ids" {
  description = "Public route table IDs"
  value       = aws_route_table.public[*].id
}

output "internet_gateway_id" {
  description = "Internet gateway ID"
  value       = length(aws_internet_gateway.public) > 0 ? aws_internet_gateway.public[0].id : null
}
