output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
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

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = aws_subnet.private_subnet[*].id
}
