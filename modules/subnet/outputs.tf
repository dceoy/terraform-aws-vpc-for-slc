output "private_subnet_azs" {
  description = "Private subnet AZs"
  value       = aws_subnet.private[*].availability_zone
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "private_route_table_ids" {
  description = "Private route table IDs"
  value       = aws_route_table.private[*].id
}

output "s3_gateway_endpoint" {
  description = "S3 gateway endpoint"
  value       = aws_vpc_endpoint.s3.id
}

output "dynamodb_gateway_endpoint" {
  description = "DynamoDB gateway endpoint"
  value       = aws_vpc_endpoint.dynamodb.id
}

output "public_subnet_azs" {
  description = "Public subnet AZs"
  value       = aws_subnet.public[*].availability_zone
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
