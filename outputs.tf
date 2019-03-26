output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "subnet_id" {
  value = "${aws_subnet.main.id}"
}

output "instance_public_ip" {
  value = "${aws_instance.web.public_ip}"
}

output "security_group_id" {
  value = "${aws_security_group.web_sg.id}"
}

output "s3_bucket_name" {
  value = "${aws_s3_bucket.app_bucket.bucket}"
}

output "rds_endpoint" {
  value = "${aws_db_instance.main.endpoint}"
}
