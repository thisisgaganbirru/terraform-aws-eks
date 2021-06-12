module "vpc" {
  source = "./modules/vpc"

  vpc_cidr            = var.vpc_cidr
  subnet_cidr         = var.subnet_cidr
  subnet_cidr_2       = var.subnet_cidr_2
  availability_zone   = var.availability_zone
  availability_zone_2 = var.availability_zone_2
}

module "iam" {
  source = "./modules/iam"

  s3_bucket_name = var.s3_bucket_name
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
}

module "s3" {
  source = "./modules/s3"

  s3_bucket_name = var.s3_bucket_name
}
