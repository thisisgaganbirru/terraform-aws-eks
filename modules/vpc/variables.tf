variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for the first subnet"
  type        = string
}

variable "subnet_cidr_2" {
  description = "CIDR block for the second subnet"
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
