resource "aws_s3_bucket" "app_bucket" {
  bucket = var.s3_bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name = "app-bucket"
  }
}
