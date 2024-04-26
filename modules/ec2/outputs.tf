output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = length(aws_instance.server) > 0 ? aws_instance.server[0].id : null
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
  value       = length(aws_key_pair.ssh) > 0 ? aws_key_pair.ssh[0].key_name : null
}

output "ec2_private_key_pem_ssm_parameter_name" {
  description = "EC2 private key PEM SSM parameter name"
  value       = length(aws_ssm_parameter.ssh) > 0 ? aws_ssm_parameter.ssh[0].name : null
}

output "ec2_instance_id_ssm_parameter_name" {
  description = "EC2 instance ID SSM parameter name"
  value       = length(aws_ssm_parameter.server) > 0 ? aws_ssm_parameter.server[0].name : null
}

output "ec2_ssm_session_iam_role_arn" {
  description = "EC2 SSM session IAM role ARN"
  value       = aws_iam_role.session.arn
}
