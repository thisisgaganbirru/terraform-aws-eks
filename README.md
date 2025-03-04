# terraform-aws-eks

Production-grade AWS infrastructure built with Terraform. Evolved over 6 years from a basic VPC/EC2/RDS setup into a fully modular, multi-environment EKS platform with GitOps-style CI/CD, IRSA-based least-privilege IAM, cost-allocation tagging, and security-hardened networking.

## Architecture

```
                          ┌─────────────────────────────────────────┐
                          │               AWS VPC                   │
                          │         10.x.0.0/16 (per env)          │
                          │                                         │
                          │  ┌─────────────┐  ┌─────────────┐      │
                          │  │  Public AZ-A │  │  Public AZ-B│      │
                          │  │  10.x.1.0/24│  │  10.x.2.0/24│      │
                          │  │  (EC2/ALB)  │  │             │      │
                          │  └──────┬──────┘  └──────┬──────┘      │
                          │         │  NAT GW         │             │
                          │  ┌──────▼──────┐  ┌──────▼──────┐      │
                          │  │ Private AZ-A│  │ Private AZ-B│      │
                          │  │  10.x.3.0/24│  │  10.x.4.0/24│      │
                          │  │  (EKS Nodes)│  │  (EKS Nodes)│      │
                          │  └─────────────┘  └─────────────┘      │
                          └─────────────────────────────────────────┘
```

### What's provisioned

| Component          | Details                                                                                                                                   |
| ------------------ | ----------------------------------------------------------------------------------------------------------------------------------------- |
| **VPC**            | Custom VPC per environment, public + private subnets across 2 AZs, NAT Gateway, route tables                                              |
| **EKS Cluster**    | Kubernetes v1.30, private node networking, full control plane logging to CloudWatch                                                       |
| **Node Groups**    | 3 groups: `main` (on-demand, general), `system` (on-demand, CriticalAddonsOnly taint), `spot` (cost-optimized, Cluster Autoscaler tagged) |
| **Managed Addons** | CoreDNS, kube-proxy, VPC CNI, EBS CSI Driver — all pinned versions                                                                        |
| **OIDC / IRSA**    | OIDC provider enabled; Cluster Autoscaler, EBS CSI, ALB Controller each have scoped IAM roles with `sub` + `aud` conditions               |
| **EC2**            | Bastion/web instance with configurable SSH CIDR, IAM instance profile, separate EBS data volume                                           |
| **RDS MySQL**      | v8.0, private subnet only, encrypted at rest, 7-day backups, deletion protection enabled                                                  |
| **S3**             | Versioned, AES256 encrypted, public access fully blocked                                                                                  |
| **Remote State**   | S3 backend with DynamoDB state locking                                                                                                    |

## Security Design

- **No hardcoded secrets** — `db_password` has no default; must be supplied via `TF_VAR_db_password` or GitHub Secrets
- **IRSA scoped trust** — each IRSA role locked to a specific `namespace:serviceaccount` via OIDC `StringEquals` condition, not cluster-wide
- **Node SG tightened** — nodes accept only 443 (from control plane) and 1025-65535 (kubelet/NodePort from control plane); no direct internet ingress
- **RDS isolated** — accepts MySQL only from the web tier security group; no public access
- **S3 hardened** — `aws_s3_bucket_public_access_block` blocks all public ACLs and policies
- **Deletion protection** — `prevent_destroy` lifecycle on RDS, S3 bucket and EKS cluster

## Environments

| Environment | tfvars                | VPC CIDR    | EKS Cluster | On-demand Nodes | Spot Nodes |
| ----------- | --------------------- | ----------- | ----------- | --------------- | ---------- |
| dev         | `envs/dev.tfvars`     | 10.0.0.0/16 | eks-dev     | 1 (max 2)       | 0-2        |
| staging     | `envs/staging.tfvars` | 10.1.0.0/16 | eks-staging | 2 (max 4)       | 0-4        |
| prod        | `envs/prod.tfvars`    | 10.2.0.0/16 | eks-prod    | 3 (max 6)       | 0-6        |

Workspaces are used to isolate state per environment. `locals.tf` resolves `Owner` and `CostCenter` tags automatically from `terraform.workspace`.

## Tagging Strategy

Every AWS resource receives a consistent set of tags via `merge(var.tags, { Name = "..." })`:

| Tag                | Value                                                          |
| ------------------ | -------------------------------------------------------------- |
| `Project`          | `terraform-aws-eks`                                            |
| `Repository`       | `thisisgaganbirru/terraform-aws-eks`                           |
| `ManagedBy`        | `terraform`                                                    |
| `Environment`      | `dev` / `staging` / `prod`                                     |
| `Owner`            | `platform-team`                                                |
| `CostCenter`       | `engineering-dev` / `engineering-staging` / `engineering-prod` |
| `TerraformVersion` | `1.9`                                                          |
| `EKSVersion`       | `1.30`                                                         |

This enables AWS Cost Explorer filtering by environment and cost center out of the box.

## Prerequisites

- Terraform >= 1.9
- AWS CLI configured (`aws configure`)
- Existing EC2 key pair in the target region
- S3 bucket and DynamoDB table for remote state must exist before `terraform init`

## Project Structure

```
├── main.tf                  # root module — wires all child modules
├── variables.tf             # input variables with validation rules
├── outputs.tf               # key outputs (cluster endpoint, vpc id, rds endpoint)
├── provider.tf              # aws + tls provider config
├── backend.tf               # s3 remote state + dynamodb locking
├── locals.tf                # workspace-aware env config, common_tags
├── terraform.tfvars.example # safe example values (no secrets)
├── envs/
│   ├── dev.tfvars           # dev environment values
│   ├── staging.tfvars       # staging environment values
│   └── prod.tfvars          # production environment values
├── .github/workflows/
│   ├── terraform.yml        # CI: fmt, validate, plan, tfsec on push/PR
│   └── terraform-apply.yml  # CD: apply on merge to main (manual approval gate)
└── modules/
    ├── vpc/    # VPC, public/private subnets, IGW, NAT, route tables
    ├── ec2/    # EC2 instance, security group, EBS volume, IAM profile
    ├── rds/    # RDS MySQL 8.0, subnet group, private security group
    ├── s3/     # S3 bucket, versioning, encryption, public access block
    ├── iam/    # IAM roles: EC2, EKS cluster, node group, IRSA roles
    │           # (Cluster Autoscaler, EBS CSI Driver, ALB Controller)
    └── eks/    # EKS cluster, 3 node groups, OIDC provider, managed addons
```

## Usage

### Clone and initialise

```bash
git clone https://github.com/thisisgaganbirru/terraform-aws-eks.git
cd terraform-aws-eks
terraform init
```

### Select workspace

```bash
terraform workspace new dev     # first time
terraform workspace select dev  # subsequent runs
```

### Plan and apply

```bash
# dev
terraform plan  -var-file="envs/dev.tfvars"     -var="db_password=$TF_VAR_db_password"
terraform apply -var-file="envs/dev.tfvars"     -var="db_password=$TF_VAR_db_password"

# staging
terraform plan  -var-file="envs/staging.tfvars" -var="db_password=$TF_VAR_db_password"
terraform apply -var-file="envs/staging.tfvars" -var="db_password=$TF_VAR_db_password"

# prod
terraform plan  -var-file="envs/prod.tfvars"    -var="db_password=$TF_VAR_db_password"
terraform apply -var-file="envs/prod.tfvars"    -var="db_password=$TF_VAR_db_password"
```

### Connect kubectl to the cluster

```bash
aws eks update-kubeconfig --region us-east-1 --name eks-dev
kubectl get nodes
```

### Destroy

```bash
terraform destroy -var-file="envs/dev.tfvars" -var="db_password=$TF_VAR_db_password"
```

> ⚠️ RDS, S3 and EKS cluster have `prevent_destroy = true`. Remove the lifecycle block before destroying production resources.

## CI/CD

### Terraform CI (`terraform.yml`)

Triggered on every **push** and **pull request** to `main`:

| Step          | Tool                   | Purpose                                       |
| ------------- | ---------------------- | --------------------------------------------- |
| Format check  | `terraform fmt -check` | Enforces consistent HCL formatting            |
| Validate      | `terraform validate`   | Checks syntax and module references           |
| Plan          | `terraform plan`       | Previews infrastructure changes               |
| Security scan | `tfsec`                | Flags misconfigurations and policy violations |

### Terraform Apply (`terraform-apply.yml`)

Triggered on **merge to main** only:

- Requires **manual approval** via GitHub Environments (`production`)
- Runs `terraform apply -auto-approve` after approval
- AWS credentials injected via GitHub Secrets — never stored in code

### Required GitHub Secrets

| Secret                  | Description              |
| ----------------------- | ------------------------ |
| `AWS_ACCESS_KEY_ID`     | AWS access key for CI/CD |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key for CI/CD |
| `DB_PASSWORD`           | RDS master password      |

## IRSA — IAM Roles for Service Accounts

Three IRSA roles are provisioned with scoped OIDC trust conditions:

| Role               | Namespace     | Service Account                | Permissions           |
| ------------------ | ------------- | ------------------------------ | --------------------- |
| Cluster Autoscaler | `kube-system` | `cluster-autoscaler`           | ASG describe/scale    |
| EBS CSI Driver     | `kube-system` | `ebs-csi-controller-sa`        | EC2 volume management |
| ALB Controller     | `kube-system` | `aws-load-balancer-controller` | ELB management        |

Each role uses `StringEquals` conditions on both `:sub` (service account) and `:aud` (audience) — preventing token reuse and cross-account escalation.

## EKS Node Groups

| Node Group | Type      | Instance                              | Use Case                                                            |
| ---------- | --------- | ------------------------------------- | ------------------------------------------------------------------- |
| `main`     | ON_DEMAND | `t3.medium`                           | General application workloads                                       |
| `system`   | ON_DEMAND | `t3.medium`                           | kube-system pods only (taint: `CriticalAddonsOnly=true:NoSchedule`) |
| `spot`     | SPOT      | `t3.medium`, `t3.large`, `t3a.medium` | Cost-optimised batch/stateless workloads                            |

Spot nodes are tagged for Cluster Autoscaler discovery:

```
k8s.io/cluster-autoscaler/<cluster-name> = owned
k8s.io/cluster-autoscaler/enabled        = true
```
