# Repository Guidelines

## Project Overview

This is a Terraform/Terragrunt project that provisions AWS VPC infrastructure for serverless computing. It uses a modular approach with Terragrunt for environment management.

## Architecture

### Module Structure

- **vpc**: Creates VPC with flow logs
- **subnet**: Creates public/private subnets across availability zones
- **nat**: NAT Gateway for private subnet internet access
- **vpce**: VPC Endpoints for AWS services (EC2, SSM, KMS, etc.)
- **kms**: KMS key for encryption
- **s3**: S3 buckets for logs and data
- **ssm**: SSM session document for EC2 access
- **ec2**: EC2 instance with SSM access (optional)

### Environment Structure

- Environments are organized under `envs/` (e.g., `envs/dev/`)
- Each module has its own Terragrunt configuration
- Dependencies between modules are explicitly defined (e.g., subnet depends on vpc)
- Remote state is stored in S3 with encryption

## Common Commands

### Initial Setup

```bash
# Initialize all modules
terragrunt run-all init --working-dir='envs/dev/' -upgrade -reconfigure

# Preview changes
terragrunt run-all plan --working-dir='envs/dev/'

# Apply changes
terragrunt run-all apply --working-dir='envs/dev/' --non-interactive
```

### Module-Specific Operations

```bash
# Work with individual modules
terragrunt plan --working-dir='envs/dev/vpc/'
terragrunt apply --working-dir='envs/dev/vpc/'

# Get outputs
terragrunt output --working-dir='envs/dev/ssm/' -raw ssm_session_document_name
```

### Cleanup

```bash
terragrunt run-all destroy --working-dir='envs/dev/' --non-interactive
```

## Development Workflow

### Linting and Validation

The project uses GitHub Actions for CI/CD. The workflow includes:

- Terraform formatting and validation
- Security scanning
- Automatic dependency updates via Dependabot/Renovate

### Testing Changes

1. Run `terragrunt plan` to preview changes
2. The CI pipeline will automatically run on push/PR
3. Lock files are automatically updated for dependency PRs

## Key Configuration

### Terragrunt Hierarchy

1. `envs/root.hcl`: Global configuration, provider generation, remote state
2. `envs/dev/env.hcl`: Environment-specific variables (account, region, system name)
3. Module-specific `terragrunt.hcl`: Dependencies and module inputs

### Important Variables

- `system_name`: Used for resource naming (default: "slc")
- `env_type`: Environment type (e.g., "dev")
- `create_ec2_instance`: Toggle EC2 instance creation
- `nat_gateway_count`: Number of NAT gateways (0 for cost savings)

### Module Dependencies

- vpc → (no dependencies)
- subnet → vpc
- nat → subnet
- vpce → vpc, subnet
- ec2 → vpc, subnet, kms, ssm
- ssm → kms, s3
