variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.30"
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster and node group"
  type        = list(string)
}

variable "node_instance_type" {
  description = "EC2 instance type for the EKS worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4
}

variable "cluster_role_arn" {
  description = "IAM role ARN for the EKS cluster"
  type        = string
}

variable "node_role_arn" {
  description = "IAM role ARN for the EKS node group"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type = string
  default = "dev"

  validation {
    condition = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging or prod"
  }
}
variable "spot_desired_size" {
  description = "Desired number of spot worker nodes"
  type = number
  default = 1
}

variable "spot_min_size" {
  description = "Minimum number of spot worker nodes"
  type = number
  default = 0
}

variable "spot_max_size" {
  description = "Maximum number of spot worker nodes"
  type = number
  default = 2
}

variable "endpoint_public_access" {
  description = "Whether the EKS API server endpoint is publicly accessible. Set to false in production."
  type        = bool
  default     = true
}

variable "addon_version_coredns" {
  description = "CoreDNS addon version compatible with the cluster version"
  type        = string
  default     = "v1.11.4-eksbuild.2"
}

variable "addon_version_kube_proxy" {
  description = "kube-proxy addon version compatible with the cluster version"
  type        = string
  default     = "v1.31.3-eksbuild.2"
}

variable "addon_version_vpc_cni" {
  description = "VPC CNI addon version compatible with the cluster version"
  type        = string
  default     = "v1.19.3-eksbuild.1"
}

variable "addon_version_ebs_csi" {
  description = "EBS CSI driver addon version compatible with the cluster version"
  type        = string
  default     = "v1.38.1-eksbuild.1"
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
