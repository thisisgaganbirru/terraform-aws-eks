# ── Networking outputs ─────────────────────────────────────────────────────────

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}

output "subnet_id" {
  description = "ID of the primary public subnet"
  value       = module.networking.subnet_id
}

output "subnet_id_2" {
  description = "ID of the secondary public subnet"
  value       = module.networking.subnet_id_2
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.networking.private_subnet_ids
}

# ── Security outputs ───────────────────────────────────────────────────────────

output "instance_profile_name" {
  description = "IAM instance profile name for EC2"
  value       = module.security.instance_profile_name
}

output "eks_cluster_role_arn" {
  description = "IAM role ARN for EKS control plane"
  value       = module.security.eks_cluster_role_arn
}

output "eks_node_role_arn" {
  description = "IAM role ARN for EKS worker nodes"
  value       = module.security.eks_node_role_arn
}
