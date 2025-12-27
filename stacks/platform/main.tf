module "eks" {
  source = "../../modules/eks"

  cluster_name             = var.cluster_name
  cluster_version          = var.cluster_version
  vpc_id                   = var.vpc_id
  subnet_ids               = var.private_subnet_ids
  node_instance_type       = var.node_instance_type
  node_desired_size        = var.node_desired_size
  node_min_size            = var.node_min_size
  node_max_size            = var.node_max_size
  cluster_role_arn         = var.eks_cluster_role_arn
  node_role_arn            = var.eks_node_role_arn
  spot_desired_size        = var.spot_desired_size
  spot_min_size            = var.spot_min_size
  spot_max_size            = var.spot_max_size
  endpoint_public_access   = var.endpoint_public_access
  environment              = var.environment
  addon_version_coredns    = var.addon_version_coredns
  addon_version_kube_proxy = var.addon_version_kube_proxy
  addon_version_vpc_cni    = var.addon_version_vpc_cni
  addon_version_ebs_csi    = var.addon_version_ebs_csi
  tags                     = var.tags
}

module "compute" {
  source = "../../modules/compute"

  instance_type        = var.instance_type
  key_name             = var.key_name
  subnet_id            = var.subnet_id
  vpc_id               = var.vpc_id
  availability_zone    = var.availability_zone
  iam_instance_profile = var.instance_profile_name
  ssh_allowed_cidr     = var.ssh_allowed_cidr
  root_volume_size     = var.root_volume_size
  data_volume_size     = var.data_volume_size
  tags                 = var.tags
}

module "storage" {
  source = "../../modules/storage"

  s3_bucket_name             = var.s3_bucket_name
  db_name                    = var.db_name
  db_username                = var.db_username
  db_password                = var.db_password
  subnet_id                  = var.subnet_id
  subnet_id_2                = var.subnet_id_2
  vpc_id                     = var.vpc_id
  web_sg_id                  = module.compute.security_group_id
  deletion_protection        = var.deletion_protection
  db_engine_version          = var.db_engine_version
  db_instance_class          = var.db_instance_class
  db_allocated_storage       = var.db_allocated_storage
  db_backup_retention_period = var.db_backup_retention_period
  tags                       = var.tags
}
