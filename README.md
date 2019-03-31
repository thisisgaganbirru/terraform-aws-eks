# terraform-aws

my terraform learning project. started this to understand aws properly before my job.

## whats in here

- VPC, subnets, internet gateway
- security groups (SSH + HTTP)
- EC2 instance (amazon linux, t2.micro)
- EBS volume attached to EC2
- RDS mysql database
- S3 bucket with versioning
- IAM role so EC2 can access S3
- remote state in S3 backend

## how to run

```bash
terraform init
terraform plan
terraform apply
```

## requirements

- aws cli configured (`aws configure`)
- an existing key pair in aws (update `key_name` in variables.tf)
- s3 bucket for remote state must exist before `terraform init`

## files

| file | what it does |
|------|------|
| main.tf | vpc, subnets, ec2 |
| variables.tf | all variables |
| provider.tf | aws provider |
| backend.tf | remote state config |
| security.tf | security groups |
| storage.tf | ebs, rds, s3 |
| iam.tf | iam role for ec2 |
| outputs.tf | output values |
