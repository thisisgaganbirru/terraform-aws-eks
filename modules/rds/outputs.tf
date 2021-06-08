output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.main.endpoint
}

output "rds_id" {
  description = "RDS instance ID"
  value       = aws_db_instance.main.id
}
