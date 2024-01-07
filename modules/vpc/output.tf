output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
}

output "vpc_default_security_group_id" {
  description = "VPC default security group ID"
  value       = aws_vpc.vpc.default_security_group_id
}

output "vpc_default_network_acl_id" {
  description = "VPC default network ACL ID"
  value       = aws_vpc.vpc.default_network_acl_id
}

output "vpc_flow_log" {
  description = "VPC flow log"
  value       = aws_flow_log.flow_log.id
}

output "vpc_flow_log_group" {
  description = "VPC flow log group"
  value       = aws_cloudwatch_log_group.vpc_logs_group.name
}

output "vpc_flow_log_iam_role" {
  description = "VPC flow log IAM role"
  value       = aws_iam_role.vpc_logs_iam_role.name
}

output "private_subnet_azs" {
  description = "Private subnet AZs"
  value       = aws_subnet.private_subnets[*].availability_zone
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = aws_subnet.private_subnets[*].id
}

output "private_route_table_ids" {
  description = "Private route table IDs"
  value       = aws_route_table.private_route_tables[*].id
}

output "s3_gateway_endpoint" {
  description = "S3 gateway endpoint"
  value       = aws_vpc_endpoint.s3_gateway_endpoint.id
}

output "dynamodb_gateway_endpoint" {
  description = "DynamoDB gateway endpoint"
  value       = aws_vpc_endpoint.dynamodb_gateway_endpoint.id
}

output "public_subnet_azs" {
  description = "Public subnet AZs"
  value       = aws_subnet.public_subnets[*].availability_zone
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = aws_subnet.public_subnets[*].id
}

output "public_route_table_id" {
  description = "Public route table ID"
  value       = aws_route_table.public_route_table.id
}

output "internet_gateway_id" {
  description = "Internet gateway ID"
  value       = aws_internet_gateway.internet_gateway.id
}
