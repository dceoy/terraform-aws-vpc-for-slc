output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.server.id
}

output "ec2_launch_template_id" {
  description = "EC2 launch template ID"
  value       = aws_launch_template.server.id
}

output "ec2_network_interface_id" {
  description = "EC2 network interface ID"
  value       = aws_network_interface.server.id
}

output "ec2_network_interface_primary_private_ip_address" {
  description = "EC2 network interface primary private IP address"
  value       = aws_network_interface.server.private_ip
}

output "ec2_instance_role_arn" {
  description = "EC2 instance role ARN"
  value       = aws_iam_role.server.arn
}

output "ec2_instance_profile_arn" {
  description = "EC2 instance profile ARN"
  value       = aws_iam_instance_profile.server.arn
}

output "ec2_key_pair_name" {
  description = "EC2 key pair name"
  value       = aws_key_pair.server.key_name
}

output "ec2_private_key_name" {
  description = "EC2 private key name"
  value       = aws_ssm_parameter.server.name
}

output "ec2_cloudwatch_log_group_name" {
  description = "EC2 CloudWatch log group name"
  value       = aws_cloudwatch_log_group.server.name
}

output "ec2_ssm_kms_key_arn" {
  description = "EC2 SSM KMS key ARN"
  value       = aws_kms_key.server.arn
}
