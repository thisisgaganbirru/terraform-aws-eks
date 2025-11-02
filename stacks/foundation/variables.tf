variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for the first public subnet"
  type        = string
}

variable "subnet_cidr_2" {
  description = "CIDR block for the second public subnet"
  type        = string
}

variable "private_subnet_cidr_1" {
  description = "CIDR block for the first private subnet"
  type        = string
}

variable "private_subnet_cidr_2" {
  description = "CIDR block for the second private subnet"
  type        = string
}

variable "availability_zone" {
  description = "Primary availability zone"
  type        = string
}

variable "availability_zone_2" {
  description = "Secondary availability zone"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name (used for subnet tagging and IAM naming)"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name for EC2 IAM policy"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
