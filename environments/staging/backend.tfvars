bucket         = "my-terraform-state-bucket"
key            = "environments/staging/terraform.tfstate"
region         = "us-east-1"
encrypt        = true
dynamodb_table = "terraform-lock"
