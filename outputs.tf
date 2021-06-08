output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "instance_public_ip" {
  description = "EC2 public IP"
  value       = module.ec2.instance_public_ip
}

output "security_group_id" {
  description = "Web security group ID"
  value       = module.ec2.security_group_id
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = module.s3.bucket_name
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = module.rds.rds_endpoint
}
