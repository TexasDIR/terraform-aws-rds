output "rds_hostname" {
  description = "RDS instance hostname"
  value       = module.db.db_instance_address
}

# output "rds_port" {
#   description = "RDS instance port"
#   value       = module.db.db_instance_port
# }
output "db_engine" {
  value = data.aws_rds_engine_version.latest.version
}

output "rds_username" {
  description = "RDS instance root username"
  value       = module.db.db_instance_username
}

output "db_identifier" {
  value       = module.db.db_instance_identifier
  description = "RDS instance identifier"
}

output "db_resource_id" {
  value       = module.db.db_instance_resource_id
  description = "RDS instance resource ID"
}