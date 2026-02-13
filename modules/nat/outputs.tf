output "nat_gateway_ids" {
  description = "NAT Gateway IDs"
  value       = aws_nat_gateway.nat[*].id
}

output "nat_gateway_addresses" {
  description = "NAT gateway addresses for regional NAT gateways"
  value       = aws_nat_gateway.nat[*].nat_gateway_addresses
}

output "nat_gateway_public_ips" {
  description = "Public IPs from NAT gateway addresses"
  value = flatten([
    for nat in aws_nat_gateway.nat : [
      for address in nat.nat_gateway_addresses : address.public_ip
    ]
  ])
}
