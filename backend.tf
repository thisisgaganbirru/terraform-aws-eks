terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket"
    key    = "terraform-aws/terraform.tfstate"
    region = "us-east-1"
  }
}
