locals {
  env = terraform.workspace

  env_config = {
    dev = {
      cost_center = "engineering-dev"
      owner       = "platform-team"
    }
    staging = {
      cost_center = "engineering-staging"
      owner       = "platform-team"
    }
    prod = {
      cost_center = "engineering-prod"
      owner       = "platform-team"
    }
    default = {
      cost_center = "engineering"
      owner       = "platform-team"
    }
  }

  current_env = lookup(local.env_config, local.env, local.env_config["default"])

  common_tags = {
    Project          = "terraform-aws-eks"
    Repository       = "thisisgaganbirru/terraform-aws-eks"
    ManagedBy        = "terraform"
    Environment      = local.env
    Owner            = local.current_env["owner"]
    CostCenter       = local.current_env["cost_center"]
    TerraformVersion = "1.9"
    EKSVersion       = "1.30"
  }
}
