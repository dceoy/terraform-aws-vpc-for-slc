output "nat_gateway_ids" {
  description = "NAT Gateway IDs"
  value       = aws_nat_gateway.nat[*].id
}

output "nat_gateway_public_ips" {
  description = "The public IPs of the NAT Gateways"
  value       = aws_eip.nat[*].public_ip
}
