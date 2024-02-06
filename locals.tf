locals {
  common_tags = {
    Project          = "terraform-aws-eks"
    ManagedBy        = "terraform"
    Env              = "dev"
    TerraformVersion = "1.6"
    EKSVersion       = "1.28"
  }
}
