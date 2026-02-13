output "nat_gateway_ids" {
  description = "NAT Gateway IDs"
  value       = aws_nat_gateway.nat[*].id
}

output "auto_provision_zones" {
  description = "Auto provision zones reported by regional NAT gateway addresses"
  value = compact(flatten([
    for nat in aws_nat_gateway.nat : [
      for address in nat.nat_gateway_addresses : try(tomap(address)["auto_provision_zones"], null)
    ]
  ]))
}

output "auto_scaling_ips" {
  description = "Auto scaling IPs reported by regional NAT gateway addresses"
  value = compact(flatten([
    for nat in aws_nat_gateway.nat : [
      for address in nat.nat_gateway_addresses : try(tomap(address)["auto_scaling_ips"], null)
    ]
  ]))
}

output "regional_nat_gateway_address" {
  description = "Regional NAT gateway addresses"
  value = flatten([
    for nat in aws_nat_gateway.nat : [
      for address in nat.nat_gateway_addresses : try(tomap(address)["regional_nat_gateway_address"], null)
    ]
  ])
}

output "route_table_id" {
  description = "Route table IDs associated with NAT routes"
  value       = aws_route.nat[*].route_table_id
}
