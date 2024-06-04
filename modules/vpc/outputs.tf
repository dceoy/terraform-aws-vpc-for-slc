output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_default_security_group_id" {
  description = "VPC default security group ID"
  value       = aws_vpc.main.default_security_group_id
}

output "vpc_default_network_acl_id" {
  description = "VPC default network ACL ID"
  value       = aws_vpc.main.default_network_acl_id
}

output "vpc_default_route_table_id" {
  description = "VPC default route table ID"
  value       = aws_vpc.main.default_route_table_id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = aws_vpc.main.cidr_block
}

output "vpc_flow_log_id" {
  description = "VPC flow log"
  value       = length(aws_flow_log.log) > 0 ? aws_flow_log.log[0].id : null
}
