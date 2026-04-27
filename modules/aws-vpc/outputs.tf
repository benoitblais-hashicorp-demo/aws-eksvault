output "private_subnets" {
  description = "List of private subnet identifiers created in the VPC."
  value       = module.vpc.private_subnets
}

output "route_table_id" {
  description = "List of private route table identifiers created in the VPC."
  value       = module.vpc.private_route_table_ids
}

output "vpc_id" {
  description = "Identifier of the VPC."
  value       = module.vpc.vpc_id
}
