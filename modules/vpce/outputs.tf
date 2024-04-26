output "ec2_interface_endpoint" {
  description = "EC2 interface endpoint"
  value       = length(aws_vpc_endpoint.ec2_interface) > 0 ? aws_vpc_endpoint.ec2_interface[0].id : null
}

output "ec2_messages_interface_endpoint" {
  description = "EC2 messages interface endpoint"
  value       = length(aws_vpc_endpoint.ec2_messages_interface) > 0 ? aws_vpc_endpoint.ec2_messages_interface[0].id : null
}

output "ssm_interface_endpoint" {
  description = "SSM interface endpoint"
  value       = length(aws_vpc_endpoint.ssm_interface) > 0 ? aws_vpc_endpoint.ssm_interface[0].id : null
}

output "ssm_messages_interface_endpoint" {
  description = "SSM messages interface endpoint"
  value       = length(aws_vpc_endpoint.ssm_messages_interface) > 0 ? aws_vpc_endpoint.ssm_messages_interface[0].id : null
}

output "secrets_manager_interface_endpoint" {
  description = "Secrets Manager interface endpoint"
  value       = length(aws_vpc_endpoint.secrets_manager_interface) > 0 ? aws_vpc_endpoint.secrets_manager_interface[0].id : null
}

output "ecr_dkr_interface_endpoint" {
  description = "ECR DKR interface endpoint"
  value       = length(aws_vpc_endpoint.ecr_dkr_interface) > 0 ? aws_vpc_endpoint.ecr_dkr_interface[0].id : null
}

output "ecr_api_interface_endpoint" {
  description = "ECR API interface endpoint"
  value       = length(aws_vpc_endpoint.ecr_api_interface) > 0 ? aws_vpc_endpoint.ecr_api_interface[0].id : null
}

output "ecs_interface_endpoint" {
  description = "ECS interface endpoint"
  value       = length(aws_vpc_endpoint.ecs_interface) > 0 ? aws_vpc_endpoint.ecs_interface[0].id : null
}

output "ecs_agent_interface_endpoint" {
  description = "ECS agent interface endpoint"
  value       = length(aws_vpc_endpoint.ecs_agent_interface) > 0 ? aws_vpc_endpoint.ecs_agent_interface[0].id : null
}

output "ecs_telemetry_interface_endpoint" {
  description = "ECS telemetry interface endpoint"
  value       = length(aws_vpc_endpoint.ecs_telemetry_interface) > 0 ? aws_vpc_endpoint.ecs_telemetry_interface[0].id : null
}

output "logs_interface_endpoint" {
  description = "Logs interface endpoint"
  value       = length(aws_vpc_endpoint.logs_interface) > 0 ? aws_vpc_endpoint.logs_interface[0].id : null
}

output "kms_interface_endpoint" {
  description = "KMS interface endpoint"
  value       = length(aws_vpc_endpoint.kms_interface) > 0 ? aws_vpc_endpoint.kms_interface[0].id : null
}
