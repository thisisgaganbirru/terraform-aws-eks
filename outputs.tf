output "vpc_id" {
  description = "VPC ID"
  value       = module.foundation.vpc_id
}

output "instance_public_ip" {
  description = "EC2 public IP"
  value       = module.platform.instance_public_ip
}

output "security_group_id" {
  description = "Web security group ID"
  value       = module.platform.security_group_id
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = module.platform.s3_bucket_name
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = module.platform.rds_endpoint
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.platform.eks_cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint URL"
  value       = module.platform.eks_cluster_endpoint
}

