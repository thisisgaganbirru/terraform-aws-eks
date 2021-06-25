# terraform-aws

AWS infrastructure using Terraform with a modular structure.

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
    ├── vpc/          # vpc, subnets, internet gateway
    ├── ec2/          # ec2 instance, security group, ebs
    ├── rds/          # rds mysql, subnet group, security group
    ├── s3/           # s3 bucket with versioning
    └── iam/          # iam role and instance profile for ec2
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

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | VPC ID |
| instance_public_ip | EC2 public IP |
| rds_endpoint | RDS connection endpoint |
| s3_bucket_name | S3 bucket name |
