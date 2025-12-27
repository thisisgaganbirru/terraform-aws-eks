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

variable "subnet_id" {
  description = "Primary subnet ID for RDS"
  type        = string
}

variable "subnet_id_2" {
  description = "Secondary subnet ID for RDS"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for RDS security group"
  type        = string
}

variable "web_sg_id" {
  description = "Web security group ID to allow MySQL access from EC2"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "deletion_protection" {
  description = "Enable deletion protection for RDS instance. Set to true in production."
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

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
