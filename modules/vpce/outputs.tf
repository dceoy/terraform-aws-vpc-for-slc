output "s3_gateway_endpoint" {
  description = "S3 gateway endpoint"
  value       = aws_vpc_endpoint.s3_gateway.id
}

output "dynamodb_gateway_endpoint" {
  description = "DynamoDB gateway endpoint"
  value       = aws_vpc_endpoint.dynamodb_gateway.id
}

output "ec2_interface_endpoint" {
  description = "EC2 interface endpoint"
  value       = aws_vpc_endpoint.ec2_interface.id
}

output "ec2_messages_interface_endpoint" {
  description = "EC2 messages interface endpoint"
  value       = aws_vpc_endpoint.ec2_messages_interface.id
}

output "ssm_interface_endpoint" {
  description = "SSM interface endpoint"
  value       = aws_vpc_endpoint.ssm_interface.id
}

output "ssm_messages_interface_endpoint" {
  description = "SSM messages interface endpoint"
  value       = aws_vpc_endpoint.ssm_messages_interface.id
}

output "secrets_manager_interface_endpoint" {
  description = "Secrets Manager interface endpoint"
  value       = aws_vpc_endpoint.secrets_manager_interface.id
}

output "ecr_dkr_interface_endpoint" {
  description = "ECR DKR interface endpoint"
  value       = aws_vpc_endpoint.ecr_dkr_interface.id
}

output "ecr_api_interface_endpoint" {
  description = "ECR API interface endpoint"
  value       = aws_vpc_endpoint.ecr_api_interface.id
}

output "ecs_interface_endpoint" {
  description = "ECS interface endpoint"
  value       = aws_vpc_endpoint.ecs_interface.id
}

output "ecs_agent_interface_endpoint" {
  description = "ECS agent interface endpoint"
  value       = aws_vpc_endpoint.ecs_agent_interface.id
}

output "ecs_telemetry_interface_endpoint" {
  description = "ECS telemetry interface endpoint"
  value       = aws_vpc_endpoint.ecs_telemetry_interface.id
}

output "logs_interface_endpoint" {
  description = "Logs interface endpoint"
  value       = aws_vpc_endpoint.logs_interface.id
}
