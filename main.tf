provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr              = var.vpc_cidr
  subnet_cidr           = var.subnet_cidr
  subnet_cidr_2         = var.subnet_cidr_2
  private_subnet_cidr_1 = var.private_subnet_cidr_1
  private_subnet_cidr_2 = var.private_subnet_cidr_2
  availability_zone     = var.availability_zone
  availability_zone_2   = var.availability_zone_2
  cluster_name          = var.cluster_name
  tags                  = local.common_tags
}

module "iam" {
  source = "./modules/iam"

  s3_bucket_name    = var.s3_bucket_name
  cluster_name      = var.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url
  tags              = local.common_tags
}

module "ec2" {
  source = "./modules/ec2"

  instance_type        = var.instance_type
  key_name             = var.key_name
  subnet_id            = module.vpc.subnet_id
  vpc_id               = module.vpc.vpc_id
  availability_zone    = var.availability_zone
  iam_instance_profile = module.iam.instance_profile_name
  ami_id               = var.ami_id
  security_group_id    = module.ec2.security_group_id
  ssh_allowed_cidr     = var.ssh_allowed_cidr
  tags                 = local.common_tags
}

module "rds" {
  source = "./modules/rds"

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  subnet_id   = module.vpc.subnet_id
  subnet_id_2 = module.vpc.subnet_id_2
  vpc_id      = module.vpc.vpc_id
  web_sg_id   = module.ec2.security_group_id
  tags        = local.common_tags
}

module "s3" {
  source = "./modules/s3"

  s3_bucket_name = var.s3_bucket_name
  tags           = local.common_tags
}

module "eks" {
  source = "./modules/eks"

  cluster_name            = var.cluster_name
  cluster_version         = var.cluster_version
  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = module.vpc.private_subnet_ids
  node_instance_type      = var.node_instance_type
  node_desired_size       = var.node_desired_size
  node_min_size           = var.node_min_size
  node_max_size           = var.node_max_size
  cluster_role_arn        = module.iam.eks_cluster_role_arn
  node_role_arn           = module.iam.eks_node_role_arn
  ebs_csi_driver_role_arn = module.iam.ebs_csi_driver_arn
  endpoint_public_access  = var.endpoint_public_access
  tags                    = local.common_tags
}

