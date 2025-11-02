module "networking" {
  source = "../../modules/networking"

  vpc_cidr              = var.vpc_cidr
  subnet_cidr           = var.subnet_cidr
  subnet_cidr_2         = var.subnet_cidr_2
  private_subnet_cidr_1 = var.private_subnet_cidr_1
  private_subnet_cidr_2 = var.private_subnet_cidr_2
  availability_zone     = var.availability_zone
  availability_zone_2   = var.availability_zone_2
  cluster_name          = var.cluster_name
  tags                  = var.tags
}

module "security" {
  source = "../../modules/security"

  s3_bucket_name = var.s3_bucket_name
  cluster_name   = var.cluster_name
  tags           = var.tags
}
