variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "Region must be a valid AWS region format e.g. us-east-1."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "VPC CIDR must be a valid IPv4 CIDR block."
  }
}

variable "subnet_cidr" {
  description = "CIDR block for the first public subnet"
  type        = string
  default     = "10.0.1.0/24"

  validation {
    condition     = can(cidrnetmask(var.subnet_cidr))
    error_message = "Subnet CIDR must be a valid IPv4 CIDR block."
  }
}

variable "subnet_cidr_2" {
  description = "CIDR block for the second public subnet"
  type        = string
  default     = "10.0.2.0/24"

  validation {
    condition     = can(cidrnetmask(var.subnet_cidr_2))
    error_message = "Subnet CIDR must be a valid IPv4 CIDR block."
  }
}

variable "private_subnet_cidr_1" {
  description = "CIDR block for the first private subnet"
  type        = string
  default     = "10.0.3.0/24"

  validation {
    condition     = can(cidrnetmask(var.private_subnet_cidr_1))
    error_message = "Private subnet CIDR must be a valid IPv4 CIDR block."
  }
}

variable "private_subnet_cidr_2" {
  description = "CIDR block for the second private subnet"
  type        = string
  default     = "10.0.4.0/24"

  validation {
    condition     = can(cidrnetmask(var.private_subnet_cidr_2))
    error_message = "Private subnet CIDR must be a valid IPv4 CIDR block."
  }
}

variable "availability_zone" {
  description = "Primary availability zone"
  type        = string
  default     = "us-east-1a"
}

variable "availability_zone_2" {
  description = "Secondary availability zone"
  type        = string
  default     = "us-east-1b"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"

  validation {
    condition     = contains(["t2.micro", "t2.small", "t2.medium", "t3.micro", "t3.small"], var.instance_type)
    error_message = "Instance type must be one of: t2.micro, t2.small, t2.medium, t3.micro, t3.small."
  }
}

variable "key_name" {
  description = "SSH key pair name for EC2 access (must exist in the target AWS region)"
  type        = string
  default     = "my-key-pair"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance (defaults to Amazon Linux 2 in us-east-1)"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}

variable "db_name" {
  description = "RDS database name"
  type        = string
  default     = "mydb"

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]*$", var.db_name))
    error_message = "DB name must start with a letter and contain only alphanumeric characters or underscores."
  }
}

variable "db_username" {
  description = "RDS master username (avoid using 'admin' or 'root' in production)"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "RDS master password - must be supplied via TF_VAR_db_password or GitHub Secrets, never hardcoded"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_password) >= 8
    error_message = "DB password must be at least 8 characters long."
  }
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "my-terraform-app-bucket"
}

variable "ssh_allowed_cidr" {
  description = "CIDR allowed to SSH into EC2 - must be your specific IP e.g. 203.0.113.0/32, not 0.0.0.0/0"
  type        = string

  validation {
    condition     = can(cidrnetmask(var.ssh_allowed_cidr))
    error_message = "SSH allowed CIDR must be a valid IPv4 CIDR block."
  }
}

variable "endpoint_public_access" {
  description = "Whether the EKS API server endpoint is publicly accessible. Set to false in production."
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "main-eks-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
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

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging or prod."
  }
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

