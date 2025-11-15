terraform {
  backend "s3" {
    # all config passed via: terraform init -backend-config="environments/<env>/backend.tfvars"
  }
}
