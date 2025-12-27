provider "aws" {
  region = var.region
}

module "foundation" {
  source = "./stacks/foundation"

  vpc_cidr              = var.vpc_cidr
  subnet_cidr           = var.subnet_cidr
  subnet_cidr_2         = var.subnet_cidr_2
  private_subnet_cidr_1 = var.private_subnet_cidr_1
  private_subnet_cidr_2 = var.private_subnet_cidr_2
  availability_zone     = var.availability_zone
  availability_zone_2   = var.availability_zone_2
  cluster_name          = var.cluster_name
  s3_bucket_name        = var.s3_bucket_name
  tags                  = local.common_tags
}

module "platform" {
  source = "./stacks/platform"

  # wired from foundation
  vpc_id                = module.foundation.vpc_id
  subnet_id             = module.foundation.subnet_id
  subnet_id_2           = module.foundation.subnet_id_2
  private_subnet_ids    = module.foundation.private_subnet_ids
  eks_cluster_role_arn  = module.foundation.eks_cluster_role_arn
  eks_node_role_arn     = module.foundation.eks_node_role_arn
  instance_profile_name = module.foundation.instance_profile_name

  # platform vars
  cluster_name               = var.cluster_name
  cluster_version            = var.cluster_version
  node_instance_type         = var.node_instance_type
  node_desired_size          = var.node_desired_size
  node_min_size              = var.node_min_size
  node_max_size              = var.node_max_size
  spot_desired_size          = var.spot_desired_size
  spot_min_size              = var.spot_min_size
  spot_max_size              = var.spot_max_size
  endpoint_public_access     = var.endpoint_public_access
  environment                = var.environment
  instance_type              = var.instance_type
  key_name                   = var.key_name
  availability_zone          = var.availability_zone
  ssh_allowed_cidr           = var.ssh_allowed_cidr
  s3_bucket_name             = var.s3_bucket_name
  db_name                    = var.db_name
  db_username                = var.db_username
  db_password                = var.db_password
  addon_version_coredns      = var.addon_version_coredns
  addon_version_kube_proxy   = var.addon_version_kube_proxy
  addon_version_vpc_cni      = var.addon_version_vpc_cni
  addon_version_ebs_csi      = var.addon_version_ebs_csi
  deletion_protection        = var.deletion_protection
  db_engine_version          = var.db_engine_version
  db_instance_class          = var.db_instance_class
  db_allocated_storage       = var.db_allocated_storage
  db_backup_retention_period = var.db_backup_retention_period
  root_volume_size           = var.root_volume_size
  data_volume_size           = var.data_volume_size
  tags                       = local.common_tags
}


