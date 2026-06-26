output "gateway_ids" {
  description = "BetterNAT provider resource IDs by availability zone."
  value       = { for az, gateway in betternat_aws_gateway.this : az => gateway.id }
}

output "egress_public_ips" {
  description = "Public egress IPs by availability zone."
  value       = merge([for gateway in betternat_aws_gateway.this : gateway.egress_public_ips]...)
}

output "active_instance_ids" {
  description = "Active gateway instance IDs by availability zone when available."
  value       = merge([for gateway in betternat_aws_gateway.this : gateway.active_instance_ids]...)
}

output "standby_instance_ids" {
  description = "Standby gateway instance IDs by availability zone when available."
  value       = merge([for gateway in betternat_aws_gateway.this : gateway.standby_instance_ids]...)
}

output "coordination_table_names" {
  description = "Provider-owned coordination table names by availability zone."
  value       = { for az, gateway in betternat_aws_gateway.this : az => gateway.coordination_table_name }
}

output "managed_route_table_ids" {
  description = "Private route table IDs managed by BetterNAT."
  value       = flatten([for gateway in betternat_aws_gateway.this : gateway.managed_route_table_ids])
}

output "agent_config_hashes" {
  description = "Rendered agent config hashes by availability zone."
  value       = { for az, gateway in betternat_aws_gateway.this : az => gateway.agent_config_hash }
}
