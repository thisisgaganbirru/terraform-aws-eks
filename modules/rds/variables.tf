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

variable "security_group_id" {
  description = "Security group ID for RDS"
  type        = string
}
