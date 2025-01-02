output "vpc_interface_endpoint_ids" {
  description = "VPC interface endpoint IDs"
  value       = { for k, v in aws_vpc_endpoint.interface : k => v.id }
}

output "vpc_interface_endpoint_dns_entries" {
  description = "VPC interface endpoint DNS entries"
  value       = { for k, v in aws_vpc_endpoint.interface : k => v.dns_entry }
}

output "vpc_interface_endpoint_network_interface_ids" {
  description = "VPC interface endpoint network interface IDs"
  value       = { for k, v in aws_vpc_endpoint.interface : k => v.network_interface_ids }
}
