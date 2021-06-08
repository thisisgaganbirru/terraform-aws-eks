output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "ID of the primary subnet"
  value       = aws_subnet.main.id
}

output "subnet_id_2" {
  description = "ID of the secondary subnet"
  value       = aws_subnet.main_2.id
}
