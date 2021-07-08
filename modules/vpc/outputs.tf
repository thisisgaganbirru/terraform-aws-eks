output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "ID of the primary public subnet"
  value       = aws_subnet.main.id
}

output "subnet_id_2" {
  description = "ID of the secondary public subnet"
  value       = aws_subnet.main_2.id
}

output "private_subnet_id_1" {
  description = "ID of the first private subnet"
  value       = aws_subnet.private_1.id
}

output "private_subnet_id_2" {
  description = "ID of the second private subnet"
  value       = aws_subnet.private_2.id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs for EKS node group"
  value       = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}
