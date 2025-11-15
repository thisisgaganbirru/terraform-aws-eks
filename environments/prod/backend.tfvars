bucket         = "my-terraform-state-bucket"
key            = "environments/prod/terraform.tfstate"
region         = "us-east-1"
encrypt        = true
dynamodb_table = "terraform-lock"
