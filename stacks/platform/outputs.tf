# ── EKS outputs ───────────────────────────────────────────────────────────────

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint URL"
  value       = module.eks.cluster_endpoint
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN for IRSA"
  value       = module.eks.oidc_provider_arn
}

# ── Compute outputs ────────────────────────────────────────────────────────────

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = module.compute.instance_public_ip
}

output "security_group_id" {
  description = "Web security group ID"
  value       = module.compute.security_group_id
}

# ── Storage outputs ────────────────────────────────────────────────────────────

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = module.storage.bucket_name
}

output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = module.storage.rds_endpoint
}
