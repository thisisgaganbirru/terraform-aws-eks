output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "Endpoint URL of the EKS cluster"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_ca_certificate" {
  description = "Base64 encoded certificate authority data for the cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS control plane"
  value       = aws_security_group.eks_cluster.id
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC Provider for IRSA"
  value = aws_iam_openid_connect_provider.eks_cluster.arn
}

output "oidc_provider_url" {
  description = "URL of the OIDC Provider"
  value       = aws_iam_openid_connect_provider.eks_cluster.url
}