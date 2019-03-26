variable "region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  default     = "10.0.1.0/24"
}

variable "subnet_cidr_2" {
  description = "CIDR block for second subnet (RDS needs 2 AZs)"
  default     = "10.0.2.0/24"
}

variable "availability_zone" {
  description = "Availability zone for subnet and EBS"
  default     = "us-east-1a"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH key pair name for EC2 access"
  default     = "my-key-pair"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance (fallback if data source fails)"
  default     = "ami-0c55b159cbfafe1f0"
}

variable "db_name" {
  description = "RDS database name"
  default     = "mydb"
}

variable "db_username" {
  description = "RDS master username"
  default     = "admin"
}

variable "db_password" {
  description = "RDS master password"
  default     = "password123"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  default     = "my-terraform-app-bucket"
}
