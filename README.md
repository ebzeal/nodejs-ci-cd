# CI/CD Pipeline with GitHub Actions, Docker & AWS ECS

A complete CI/CD pipeline that builds a Node.js web application, containerizes it
with Docker, provisions AWS infrastructure with Terraform, and deploys
automatically to Amazon ECS (Fargate) using GitHub Actions.

The app responds with:

```
Hello from CI/CD Pipeline!
```

## Architecture

```
GitHub repo ──push to main──▶ GitHub Actions
                                  │
                                  ├─▶ Build Docker image
                                  ├─▶ Push image to Amazon ECR
                                  └─▶ Update ECS service (Fargate)

AWS (via Terraform)
   ├─ VPC + public subnets + Internet Gateway
   ├─ Security groups (ALB + ECS)
   ├─ ECR repository
   ├─ ECS cluster + task definition + service
   └─ Application Load Balancer ──▶ http://<alb-dns>
```

## Repository Structure

```
ci_cd_nodejs/
├── index.js                 # Node.js web app
├── package.json             # Dependencies & scripts
├── pnpm-lock.yaml           # Lockfile
├── Dockerfile               # Container image definition
├── .dockerignore
├── .gitignore
├── terraform/               # Infrastructure as code (Terraform)
│   ├── providers.tf         # AWS provider config
│   ├── variables.tf         # Input variables
│   ├── vpc.tf               # VPC, subnets, IGW, route tables, security groups
│   ├── ecr.tf               # ECR repository
│   ├── ecs.tf               # ECS cluster, task definition, service, IAM
│   ├── alb.tf               # Application Load Balancer
│   └── outputs.tf           # Output values
├── .github/
│   └── workflows/           # GitHub Actions CI/CD pipeline
└── README.md
```

## Prerequisites

- [Node.js](https://nodejs.org/) 20+
- [pnpm](https://pnpm.io/) or npm
- [Docker](https://www.docker.com/)
- [Terraform](https://www.terraform.io/) 1.5+
- [AWS CLI](https://aws.amazon.com/cli/) configured with credentials
- A GitHub repository

## 1. Run the App Locally

```bash
pnpm install
pnpm start
```

Open `http://localhost:3000` — you should see `Hello from CI/CD Pipeline!`.

## 2. Build & Run with Docker

```bash
# Build the image
docker build -t ci-cd-nodejs .

# Run the container
docker run -d -p 3000:3000 --name ci-cd-nodejs ci-cd-nodejs

# Verify
curl http://localhost:3000
# → Hello from CI/CD Pipeline!

# Stop & remove
docker rm -f ci-cd-nodejs
```

## 3. Provision AWS Infrastructure with Terraform

```bash
cd terraform

# Initialize
terraform init

# Review the plan
terraform plan

# Apply
terraform apply
```

Terraform provisions:

- VPC, public subnets, Internet Gateway, route tables
- Security groups for the ALB and ECS tasks
- ECR repository (`ci-cd-nodejs`)
- ECS cluster, task definition, and Fargate service
- Application Load Balancer with a target group

After applying, note the outputs:

```bash
terraform output
```

- `ecr_repository_url` — used by the CI/CD pipeline
- `alb_dns_name` — public URL of the deployed app

## 4. Configure GitHub Actions Secrets

Add the following secrets to your GitHub repository
(`Settings → Secrets and variables → Actions`):

| Secret                    | Description                          |
| ------------------------- | ------------------------------------ |
| `AWS_ACCESS_KEY_ID`       | AWS access key                       |
| `AWS_SECRET_ACCESS_KEY`   | AWS secret access key                |
| `AWS_REGION`              | AWS region (e.g. `us-east-1`)        |
| `ECR_REPOSITORY`          | ECR repository name (`ci-cd-nodejs`) |
| `ECS_CLUSTER`             | ECS cluster name                     |
| `ECS_SERVICE`             | ECS service name                     |
| `ECS_TASK_DEFINITION`     | ECS task definition family           |

## 5. CI/CD Pipeline (GitHub Actions)

The workflow in `.github/workflows/` runs automatically on every push to `main`:

1. Checks out the repository
2. Builds the Docker image
3. Authenticates to Amazon ECR
4. Pushes the image to ECR
5. Updates the ECS service to deploy the new image

## Cleanup

```bash
# Destroy AWS infrastructure
cd terraform
terraform destroy
```
