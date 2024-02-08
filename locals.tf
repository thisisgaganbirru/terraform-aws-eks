locals {
  env = terraform.workspace

  common_tags = {
    Project          = "terraform-aws-eks"
    ManagedBy        = "terraform"
    Env              = local.env
    TerraformVersion = "1.6"
    EKSVersion       = "1.28"
  }
}
