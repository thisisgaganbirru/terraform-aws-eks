variable "s3_bucket_name" {
  description = "S3 bucket name for EC2 IAM policy"
  type        = string
}

variable "cluster_name" {
  description = "EKS Cluster name"
  type = string
}

variable "oidc_provider_arn" {
  description = "OIDC provider ARN for IRSA"
  type = string
}