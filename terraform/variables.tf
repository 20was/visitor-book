# Variables Configuration
# This file defines all the configurable parameters for our infrastructure.
# Think of these as settings that can be changed without modifying the main code.
# Similar to how you might have different settings for different environments (dev, staging, prod)

# AWS Region variable
# This determines which AWS region to deploy resources in
# Different regions have different availability and pricing
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"  # Default to US East (N. Virginia)
}

# Environment variable
# This helps distinguish between different deployment environments
# Like having different buildings for different purposes (office, warehouse, etc.)
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"  # Default to development environment
}

# VPC CIDR block variable
# This defines the IP address range for our VPC
# Like defining the size of our private network
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"  # Default to a /16 network (65,536 IP addresses)
}

# Public subnet CIDR blocks
# These define the IP ranges for our public subnets
# Like defining different floors in our building that are accessible from outside
variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]  # Two /24 networks (256 IPs each)
}

# Private subnet CIDR blocks
# These define the IP ranges for our private subnets
# Like defining secure areas in our building that aren't directly accessible
variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]  # Two /24 networks (256 IPs each)
}

# Database username variable
# This is the username for our RDS PostgreSQL instance
# Marked as sensitive to prevent it from being displayed in logs
variable "db_username" {
  description = "Username for the RDS PostgreSQL instance"
  type        = string
  default     = "postgres"  # Default PostgreSQL username
  sensitive   = true        # Mark as sensitive for security
}

# Database password variable
# This is the password for our RDS PostgreSQL instance
# Marked as sensitive to prevent it from being displayed in logs
variable "db_password" {
  description = "Password for the RDS PostgreSQL instance"
  type        = string
  sensitive   = true  # Mark as sensitive for security
}

# EC2 instance type variable
# This determines the size and capabilities of our EC2 instances
# Like choosing the size of a computer (small, medium, large)
variable "ec2_instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t3.micro"  # Default to t3.micro (1 vCPU, 1 GB RAM)
}

# SSH key name variable
# This is the name of the SSH key pair to use for EC2 instances
# Like having a specific key for accessing different buildings
variable "ssh_key_name" {
  description = "Name of the SSH key to use for EC2 instances"
  type        = string
}