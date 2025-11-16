locals {
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

  current_env = lookup(local.env_config, var.environment, local.env_config["default"])

  common_tags = {
    Project          = "terraform-aws-eks"
    Repository       = "thisisgaganbirru/terraform-aws-eks"
    ManagedBy        = "terraform"
    Environment      = var.environment
    Owner            = local.current_env["owner"]
    CostCenter       = local.current_env["cost_center"]
    TerraformVersion = "1.9"
    EKSVersion       = "1.30"
  }
}

