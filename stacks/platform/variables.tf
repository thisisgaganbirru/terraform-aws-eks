# ── Passed in from foundation stack ───────────────────────────────────────────

variable "vpc_id" {
  description = "VPC ID from foundation stack"
  type        = string
}

variable "subnet_id" {
  description = "Primary public subnet ID from foundation stack"
  type        = string
}

variable "subnet_id_2" {
  description = "Secondary public subnet ID from foundation stack"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs from foundation stack"
  type        = list(string)
}

variable "eks_cluster_role_arn" {
  description = "EKS cluster IAM role ARN from foundation stack"
  type        = string
}

variable "eks_node_role_arn" {
  description = "EKS node IAM role ARN from foundation stack"
  type        = string
}

variable "instance_profile_name" {
  description = "EC2 IAM instance profile name from foundation stack"
  type        = string
}

# ── EKS ────────────────────────────────────────────────────────────────────────

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.30"
}

variable "node_instance_type" {
  description = "EC2 instance type for EKS worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "node_desired_size" {
  description = "Desired number of EKS worker nodes"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of EKS worker nodes"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of EKS worker nodes"
  type        = number
  default     = 4
}

variable "spot_desired_size" {
  description = "Desired number of spot worker nodes"
  type        = number
  default     = 1
}

variable "spot_min_size" {
  description = "Minimum number of spot worker nodes"
  type        = number
  default     = 0
}

variable "spot_max_size" {
  description = "Maximum number of spot worker nodes"
  type        = number
  default     = 2
}

variable "endpoint_public_access" {
  description = "Whether the EKS API endpoint is publicly accessible"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

# ── Compute ────────────────────────────────────────────────────────────────────

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}


variable "availability_zone" {
  description = "Primary availability zone"
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "CIDR allowed to SSH into EC2"
  type        = string
}

# ── Storage ────────────────────────────────────────────────────────────────────

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "db_name" {
  description = "RDS database name"
  type        = string
}

variable "db_username" {
  description = "RDS master username"
  type        = string
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

# ── Common ─────────────────────────────────────────────────────────────────────

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "addon_version_coredns" {
  description = "CoreDNS addon version"
  type        = string
  default     = "v1.11.4-eksbuild.2"
}

variable "addon_version_kube_proxy" {
  description = "kube-proxy addon version"
  type        = string
  default     = "v1.31.3-eksbuild.2"
}

variable "addon_version_vpc_cni" {
  description = "VPC CNI addon version"
  type        = string
  default     = "v1.19.3-eksbuild.1"
}

variable "addon_version_ebs_csi" {
  description = "EBS CSI driver addon version"
  type        = string
  default     = "v1.38.1-eksbuild.1"
}

variable "deletion_protection" {
  description = "Enable deletion protection for RDS instance"
  type        = bool
  default     = false
}

variable "db_engine_version" {
  description = "MySQL engine version for RDS"
  type        = string
  default     = "8.0"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage for RDS instance in GB"
  type        = number
  default     = 20
}

variable "db_backup_retention_period" {
  description = "Number of days to retain RDS automated backups"
  type        = number
  default     = 7
}

variable "root_volume_size" {
  description = "Size of the root EBS volume in GB"
  type        = number
  default     = 20
}

variable "data_volume_size" {
  description = "Size of the data EBS volume in GB"
  type        = number
  default     = 20
}
