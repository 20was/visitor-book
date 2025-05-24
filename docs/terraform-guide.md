# Terraform Infrastructure Guide for Visitor Book Project

## Table of Contents

1. [Introduction](#introduction)
2. [Project Structure](#project-structure)
3. [Provider Configuration](#provider-configuration)
4. [VPC and Networking](#vpc-and-networking)
5. [Variables and Configuration](#variables-and-configuration)
6. [Common Commands](#common-commands)
7. [Best Practices](#best-practices)

## Introduction

This guide explains the Terraform infrastructure setup for the Visitor Book project. Terraform is an Infrastructure as Code (IaC) tool that allows us to define and manage our cloud infrastructure using code. Think of it like a blueprint for your entire cloud infrastructure.

### Why Terraform?

- **Reproducibility**: Infrastructure can be recreated exactly the same way every time
- **Version Control**: Track changes to your infrastructure like code
- **Automation**: Automate infrastructure deployment and updates
- **Documentation**: Infrastructure is self-documenting through code

## Project Structure

```
terraform/
├── environments/          # Environment-specific configurations
├── modules/              # Reusable Terraform modules
├── outputs.tf            # Output definitions
├── provider.tf           # AWS provider configuration
├── variables.tf          # Variable definitions
└── vpc.tf               # VPC and networking setup
```

## Provider Configuration

File: `provider.tf`

This file configures how Terraform interacts with AWS. Think of it as setting up your cloud toolbox.

### Key Components:

```hcl
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Project = "VisitorBook"
      Owner   = "DevOpsLearner"
    }
  }
}
```

- **Region**: Specifies which AWS region to deploy resources in
- **Default Tags**: Automatically applies tags to all resources for better organization

## VPC and Networking

File: `vpc.tf`

This file defines our Virtual Private Cloud (VPC) and networking components. Think of VPC as your private network in the cloud.

### Key Components:

1. **VPC** (`aws_vpc.main`):

   - Creates a private network with IP range 10.0.0.0/16
   - Enables DNS support for better resource naming

2. **Internet Gateway** (`aws_internet_gateway.main`):

   - Allows resources in the VPC to connect to the internet
   - Like a gateway between your private network and the public internet

3. **Subnets**:

   - **Public Subnet** (`aws_subnet.public`):
     - IP range: 10.0.1.0/24
     - Located in us-east-1a
     - Resources here can be accessed from the internet
   - **Private Subnet** (`aws_subnet.private`):
     - IP range: 10.0.2.0/24
     - Located in us-east-1b
     - Resources here are not directly accessible from the internet

4. **Security Groups** (`aws_security_group.ec2`):
   - Controls traffic to and from resources
   - Allows:
     - SSH (port 22)
     - HTTP (port 80)
     - HTTPS (port 443)
   - All outbound traffic is allowed

## Variables and Configuration

File: `variables.tf`

This file defines all configurable parameters for our infrastructure. Think of these as settings that can be changed without modifying the main code.

### Key Variables:

1. **AWS Region**:

   ```hcl
   variable "aws_region" {
     description = "AWS region to deploy resources"
     type        = string
     default     = "us-east-1"
   }
   ```

2. **Environment**:

   ```hcl
   variable "environment" {
     description = "Environment name (dev, staging, prod)"
     type        = string
     default     = "dev"
   }
   ```

3. **Network Configuration**:

   - VPC CIDR block
   - Public and private subnet CIDR blocks

4. **Database Configuration**:
   - Username and password (marked as sensitive)
   - Instance type

## Common Commands

Here are the essential Terraform commands you'll use:

1. **Initialize Terraform**:

   ```bash
   terraform init
   ```

   - Downloads required providers
   - Initializes the working directory

2. **Plan Changes**:

   ```bash
   terraform plan
   ```

   - Shows what changes will be made
   - Like a blueprint review before construction

3. **Apply Changes**:

   ```bash
   terraform apply
   ```

   - Creates or updates infrastructure
   - Like starting the actual construction

4. **Destroy Infrastructure**:
   ```bash
   terraform destroy
   ```
   - Removes all created resources
   - Like demolition of a building

## Best Practices

1. **State Management**:

   - Use remote state storage (S3 + DynamoDB)
   - Never commit state files to version control

2. **Security**:

   - Use IAM roles with least privilege
   - Store sensitive variables securely
   - Use private subnets for sensitive resources

3. **Organization**:

   - Use consistent naming conventions
   - Tag all resources appropriately
   - Use modules for reusable components

4. **Version Control**:
   - Commit Terraform files to version control
   - Use meaningful commit messages
   - Review changes before applying

## Visual Architecture

```
                    Internet
                        │
                        ▼
                Internet Gateway
                        │
                        ▼
                    VPC (10.0.0.0/16)
                        │
        ┌──────────────┴──────────────┐
        ▼                             ▼
Public Subnet                    Private Subnet
(10.0.1.0/24)                   (10.0.2.0/24)
    │                                │
    ▼                                ▼
EC2 Instance                    RDS Database
(Web Server)                    (PostgreSQL)
```

## Troubleshooting

Common issues and solutions:

1. **Provider Authentication**:

   - Ensure AWS credentials are properly configured
   - Check AWS CLI configuration

2. **State Lock Issues**:

   - Check if another process is running Terraform
   - Verify DynamoDB table exists for state locking

3. **Resource Creation Failures**:
   - Check AWS service limits
   - Verify IAM permissions
   - Review security group rules

## Next Steps

1. Set up remote state storage
2. Create additional modules for:
   - EC2 instances
   - RDS database
   - Load balancer
3. Implement CI/CD pipeline for infrastructure changes
4. Add monitoring and logging resources
