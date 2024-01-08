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

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = aws_vpc.main.cidr_block
}

output "vpc_flow_log_id" {
  description = "VPC flow log"
  value       = aws_flow_log.flow_log.id
}

output "vpc_flow_log_cloudwatch_log_group_name" {
  description = "VPC flow log CloudWatch log group name"
  value       = aws_cloudwatch_log_group.flow_log.name
}

output "vpc_flow_log_iam_role_arn" {
  description = "VPC flow log IAM role ARN"
  value       = aws_iam_role.flow_log.arn
}
