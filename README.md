# terraform-aws

AWS infrastructure using Terraform with a modular structure. Includes VPC, EC2, RDS, S3, IAM, and EKS.

## Prerequisites

- Terraform >= 0.14
- AWS CLI configured (`aws configure`)
- Existing EC2 key pair in AWS
- S3 bucket for remote state must exist before running `terraform init`

## Structure

```
├── main.tf           # root module, calls all child modules
├── variables.tf      # input variables with validation
├── outputs.tf        # output values
├── provider.tf       # aws provider config
├── backend.tf        # remote state config
├── terraform.tfvars  # variable values
└── modules/
    ├── vpc/          # vpc, public/private subnets, nat gateway, route tables
    ├── ec2/          # ec2 instance, security group, ebs
    ├── rds/          # rds mysql, subnet group, security group
    ├── s3/           # s3 bucket with versioning
    ├── iam/          # iam roles for ec2 and eks
    └── eks/          # eks cluster, managed node group, security groups
```

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Inputs

| Name | Description | Default |
|------|-------------|---------|
| region | AWS region | us-east-1 |
| instance_type | EC2 instance type | t2.micro |
| db_password | RDS master password | - |
| ssh_allowed_cidr | CIDR allowed to SSH | 0.0.0.0/0 |
| private_subnet_cidr_1 | First private subnet CIDR | 10.0.3.0/24 |
| private_subnet_cidr_2 | Second private subnet CIDR | 10.0.4.0/24 |
| cluster_name | EKS cluster name | main-eks-cluster |
| cluster_version | Kubernetes version | 1.20 |
| node_instance_type | EKS worker node instance type | t3.medium |
| node_desired_size | Desired number of worker nodes | 2 |
| node_min_size | Minimum number of worker nodes | 1 |
| node_max_size | Maximum number of worker nodes | 4 |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | VPC ID |
| instance_public_ip | EC2 public IP |
| rds_endpoint | RDS connection endpoint |
| s3_bucket_name | S3 bucket name |
| eks_cluster_name | EKS cluster name |
| eks_cluster_endpoint | EKS cluster API endpoint |

