# Infrastructure - Honey-Do

Terraform infrastructure as code for deploying the Honey-Do application on AWS.

## Overview

The infrastructure is built using Terraform with a modular design, allowing for reusable components and multi-environment deployments. The setup provisions all necessary AWS resources including S3 for static hosting, API Gateway for REST endpoints, and Lambda functions for backend logic.

## Prerequisites

Before setting up the infrastructure, ensure you have the following installed:

- **Terraform 1.2+**: Infrastructure as code tool ([installation guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli))
- **AWS CLI**: Command line tool for AWS ([installation guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html))
- **AWS Account**: Active AWS account with appropriate permissions

## AWS Credentials Setup

Configure your AWS credentials using one of the following methods:

### Option 1: AWS CLI Configuration

```bash
aws configure
```

Provide your:

- AWS Access Key ID
- AWS Secret Access Key
- Default region (e.g., `us-east-1`)
- Default output format (e.g., `json`)

### Option 2: Environment Variables

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

### Option 3: AWS Credentials File

Create `~/.aws/credentials`:

```ini
[default]
aws_access_key_id = your-access-key
aws_secret_access_key = your-secret-key
```

## Project Structure

```markdown
infrastructure/
├── modules/                    # Reusable Terraform modules
│   ├── s3-static-website/     # S3 static website hosting module
│   │   ├── main.tf            # S3 bucket and policy configuration
│   │   ├── variables.tf       # Module input variables
│   │   └── outputs.tf         # Module output values
│   └── api-gateway-lambda/    # API Gateway + Lambda integration module
│       ├── main.tf            # API Gateway configuration
│       ├── lambda.tf          # Lambda function resources
│       ├── variables.tf       # Module input variables
│       └── outputs.tf         # Module output values
├── environments/               # Environment-specific configurations
│   ├── dev/                   # Development environment
│   │   ├── main.tf            # Module instantiation
│   │   ├── variables.tf       # Environment variables
│   │   ├── outputs.tf         # Environment outputs
│   │   └── terraform.tfvars   # Variable values
│   ├── stg/                   # Staging (planned)
│   └── prod/                  # Production (planned)
├── main.tf                    # Root Terraform configuration
├── terraform.tf               # Terraform and provider requirements
└── README.md                  # This file
```

## Terraform Modules

### s3-static-website

Provisions an S3 bucket configured for static website hosting with public access.

**Features:**

- Public read access for website content
- Static website hosting configuration
- Automatic MIME type detection for uploaded files
- Configurable index and error documents

**Usage:**

```hcl
module "static_website" {
  source      = "../../modules/s3-static-website"
  bucket_name = "my-app-website"
  source_dir  = "../../client/dist"
  environment = "dev"
}
```

### api-gateway-lambda

Creates a REST API using API Gateway with Lambda function integration.

**Features:**

- REST API with configurable routes and methods
- Lambda function deployment from source code
- Automatic deployment triggers on code changes
- CloudWatch logging integration
- CORS support
- IAM roles and permissions

**Usage:**

```hcl
module "api" {
  source = "../../modules/api-gateway-lambda"

  environment        = var.environment
  api_name           = var.api_name
  lambda_name        = var.lambda_name
  lambda_handler     = "handler.handler"
  lambda_runtime     = "python3.13"
  backend_source_dir = "${path.root}/../../../backend/src/tasks"

  routes = [
    {
      path        = "tasks"
      http_method = "GET"
    },
    {
      path        = "tasks"
      http_method = "POST"
    },
  ]

  tags = {
    Environment = var.environment
    Project     = "honey-do"
    ManagedBy   = "terraform"
  }
}

```

## Deployment

### Initial Setup

1. **Navigate to the desired environment directory**:

   ```bash
   cd infrastructure/environments/dev
   ```

2. **Initialize Terraform**:

   ```bash
   terraform init
   ```

   This downloads required providers and initializes the backend.

3. **Review the configuration**:

   Edit `terraform.tfvars` to customize values:

   ```hcl
   environment = "dev"
   bucket_name = "honey-do-dev-static-website"
   source_dir  = "../../../client/dist"
   ```

### Planning Changes

Before applying changes, preview what Terraform will do:

```bash
terraform plan
```

This shows:

- Resources to be created
- Resources to be modified
- Resources to be destroyed

### Applying Changes

To deploy or update the infrastructure:

```bash
terraform apply
```

Review the plan and type `yes` to confirm.

### Destroying Infrastructure

To tear down all resources (use with caution):

```bash
terraform destroy
```

## Development Workflow

### Format Terraform Files

Automatically format `.tf` files:

```bash
terraform fmt -recursive
```

### Validate Configuration

Check configuration for syntax errors:

```bash
terraform validate
```

### View Outputs

Display output values from the current state:

```bash
terraform output
```

View a specific output:

```bash
terraform output website_url
```

### View Current State

List all resources in the current state:

```bash
terraform state list
```

Show details of a specific resource:

```bash
terraform state show <resource-address>
```

## Environment Management

### Working with Multiple Environments

Each environment (dev, stg, prod) has its own directory with:

- Independent state files
- Environment-specific variable values
- Isolated AWS resources

To deploy to a different environment:

```bash
cd infrastructure/environments/prod
terraform init
terraform plan
terraform apply
```

### Environment Variables

Each environment can override default values in `terraform.tfvars`:

```hcl
# environments/dev/terraform.tfvars
environment = "dev"
bucket_name = "honey-do-dev-static-website"

# environments/prod/terraform.tfvars
environment = "prod"
bucket_name = "honey-do-prod-static-website"
```

## Deployment Process

### Complete Deployment Flow

1. **Build the frontend**:

   ```bash
   cd client
   pnpm build
   ```

2. **Package Lambda functions**:

   ```bash
   # Backend packaging handled by Terraform
   ```

3. **Deploy infrastructure**:

   ```bash
   cd infrastructure/environments/dev
   terraform apply
   ```

4. **Verify deployment**:

   ```bash
   terraform output website_url
   terraform output api_endpoint
   ```

## Outputs

After deployment, Terraform provides important URLs and identifiers:

- `website_url` - S3 static website endpoint
- `website_bucket_name` - S3 bucket name
- `api_endpoint` - API Gateway invoke URL
- `api_id` - API Gateway REST API ID
