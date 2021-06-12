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
