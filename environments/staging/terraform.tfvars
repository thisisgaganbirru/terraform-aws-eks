region                = "us-east-1"
vpc_cidr              = "10.1.0.0/16"
subnet_cidr           = "10.1.1.0/24"
subnet_cidr_2         = "10.1.2.0/24"
private_subnet_cidr_1 = "10.1.3.0/24"
private_subnet_cidr_2 = "10.1.4.0/24"
availability_zone     = "us-east-1a"
availability_zone_2   = "us-east-1b"
instance_type         = "t3.small"
key_name              = "my-key-pair"
db_name               = "mydb"
db_username           = "admin"
s3_bucket_name        = "terraform-k8s-max-staging"
cluster_name          = "eks-staging"
cluster_version       = "1.30"
node_instance_type    = "t3.medium"
node_desired_size     = 2
node_min_size         = 1
node_max_size         = 4
environment           = "staging"
spot_desired_size     = 2
spot_min_size         = 0
spot_max_size         = 4
endpoint_public_access = true
# ssh_allowed_cidr — do NOT commit. Pass at runtime:
# terraform apply -var="ssh_allowed_cidr=YOUR_IP/32"
# or export TF_VAR_ssh_allowed_cidr=YOUR_IP/32

# Terraform meta
terraform_version = "1.9"

# EKS addon versions (for EKS 1.30)
addon_version_coredns    = "v1.11.3-eksbuild.1"
addon_version_kube_proxy = "v1.30.6-eksbuild.3"
addon_version_vpc_cni    = "v1.19.2-eksbuild.1"
addon_version_ebs_csi    = "v1.37.0-eksbuild.1"

# RDS config
deletion_protection        = false
db_engine_version          = "8.0"
db_instance_class          = "db.t3.micro"
db_allocated_storage       = 20
db_backup_retention_period = 7

# EC2 volume sizes (GB)
root_volume_size = 20
data_volume_size = 20
