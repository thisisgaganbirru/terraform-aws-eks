# terraform-aws-eks

Production-grade AWS infrastructure provisioned with Terraform. This project evolved from a simple AWS setup into a fully modular, multi-environment EKS platform with automated CI/CD, IRSA-based IAM, and security-hardened networking.

## Architecture Overview

This project provisions the following AWS infrastructure:

- **VPC** — Custom VPC with public and private subnets across 2 availability zones, NAT Gateway for private subnet egress, and route tables
- **EKS Cluster** — Managed Kubernetes cluster (v1.30) with 3 node groups:
  - `main` — On-demand nodes for general workloads
  - `system` — Dedicated on-demand nodes for kube-system with `CriticalAddonsOnly` taint
  - `spot` — Spot instances for cost-optimized workloads, tagged for Cluster Autoscaler
- **EKS Managed Add-ons** — Pinned versions of CoreDNS, kube-proxy, VPC CNI, and EBS CSI Driver
- **OIDC Provider** — Enables IAM Roles for Service Accounts (IRSA) for secure pod-level AWS access
- **IAM Roles** — Least-privilege roles for EKS cluster, node groups, Cluster Autoscaler, EBS CSI Driver, and AWS Load Balancer Controller
- **EC2** — Bastion/web instance with configurable SSH access and IAM instance profile
- **RDS MySQL** — Private subnet RDS instance, accessible only from the web tier security group
- **S3** — Versioned S3 bucket for application storage
- **Remote State** — Terraform state stored in S3 with DynamoDB locking

## Prerequisites

- Terraform >= 1.9
- AWS CLI configured (`aws configure`)
- Existing EC2 key pair in AWS
- S3 bucket for remote state must exist before running `terraform init`

## Structure

```
├── main.tf               # root module, wires all child modules together
├── variables.tf          # input variables with validation rules
├── outputs.tf            # output values exposed from root module
├── provider.tf           # aws and tls provider config
├── backend.tf            # s3 remote state and dynamodb lock config
├── locals.tf             # common tags and workspace-aware locals
├── envs/
│   ├── dev.tfvars        # dev environment variable values
│   └── staging.tfvars    # staging environment variable values
├── .github/
│   └── workflows/
│       ├── terraform.yml        # ci: fmt, validate, plan, tfsec on PR
│       └── terraform-apply.yml  # cd: apply on merge to main (manual approval)
└── modules/
    ├── vpc/    # vpc, public/private subnets, nat gateway, route tables, igw
    ├── ec2/    # ec2 instance, security group, ebs volume, iam profile
    ├── rds/    # rds mysql, db subnet group, private security group
    ├── s3/     # s3 bucket with versioning enabled
    ├── iam/    # iam roles for ec2, eks cluster, node group, cluster autoscaler,
    │           # ebs csi driver, aws load balancer controller
    └── eks/    # eks cluster, 3 node groups (main/system/spot), oidc provider,
                # pinned managed addons (coredns, kube-proxy, vpc-cni, ebs-csi)
```

## Usage

### Clone and init

```bash
git clone https://github.com/thisisgaganbirru/terraform-aws-eks.git
cd terraform-aws-eks
terraform init
```

### Deploy to dev

```bash
terraform plan -var-file="envs/dev.tfvars" -var="db_password=$TF_VAR_db_password"
terraform apply -var-file="envs/dev.tfvars" -var="db_password=$TF_VAR_db_password"
```

### Deploy to staging

```bash
terraform plan -var-file="envs/staging.tfvars" -var="db_password=$TF_VAR_db_password"
terraform apply -var-file="envs/staging.tfvars" -var="db_password=$TF_VAR_db_password"
```

### Destroy

```bash
terraform destroy -var-file="envs/dev.tfvars" -var="db_password=$TF_VAR_db_password"
```

## CI/CD

This project uses GitHub Actions for automated testing and deployment.

### Terraform CI (`terraform.yml`)

Triggered on every **push** and **pull request** to `main`:

- `terraform fmt -check` — enforces consistent formatting
- `terraform validate` — checks configuration syntax
- `terraform plan` — previews infrastructure changes
- `tfsec` — static security analysis, flags misconfigurations

### Terraform Apply (`terraform-apply.yml`)

Triggered on **merge to main** only:

- Requires manual approval via GitHub Environments (`production`)
- Runs `terraform apply -auto-approve` after approval
- AWS credentials injected via GitHub Secrets

### Required GitHub Secrets

| Secret                  | Description              |
| ----------------------- | ------------------------ |
| `AWS_ACCESS_KEY_ID`     | AWS access key for CI/CD |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key for CI/CD |
| `DB_PASSWORD`           | RDS master password      |

> `db_password` is excluded from tfvars. Pass it via `TF_VAR_db_password` locally or via GitHub Secrets in CI.

## Environments

| Environment | tfvars file           | VPC CIDR    | EKS Cluster | Node Size       |
| ----------- | --------------------- | ----------- | ----------- | --------------- |
| dev         | `envs/dev.tfvars`     | 10.0.0.0/16 | eks-dev     | 1 node (max 2)  |
| staging     | `envs/staging.tfvars` | 10.1.0.0/16 | eks-staging | 2 nodes (max 4) |
