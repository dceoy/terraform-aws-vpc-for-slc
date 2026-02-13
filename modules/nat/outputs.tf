output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = length(aws_nat_gateway.nat) > 0 ? aws_nat_gateway.nat[0].id : null
}

output "nat_auto_provision_zones" {
  description = "Auto provision zones reported by regional NAT gateway"
  value       = length(aws_nat_gateway.nat) > 0 ? aws_nat_gateway.nat[0].auto_provision_zones : null
}

output "nat_auto_scaling_ips" {
  description = "Auto scaling IPs reported by regional NAT gateway"
  value       = length(aws_nat_gateway.nat) > 0 ? aws_nat_gateway.nat[0].auto_scaling_ips : null
}

output "nat_gateway_address" {
  description = "Regional NAT gateway address"
  value       = length(aws_nat_gateway.nat) > 0 ? aws_nat_gateway.nat[0].regional_nat_gateway_address : null
}

output "nat_route_table_id" {
  description = "ID of the route table created for the NAT gateway"
  value       = length(aws_nat_gateway.nat) > 0 ? aws_nat_gateway.nat[0].route_table_id : null
}
