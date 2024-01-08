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
