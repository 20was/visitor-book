# AWS Provider Configuration
# This file configures how Terraform interacts with AWS.
# Think of this as setting up your "cloud toolbox" - it tells Terraform which cloud provider to use
# and how to connect to it. Similar to how you'd need to set up your tools before starting a construction project.

provider "aws" {
  # Specifies which AWS region to deploy resources in
  # This is like choosing which city/area you want to build your infrastructure in
  # Different regions have different availability and pricing
  region = "us-east-1"  # Choose your preferred region
  
  # Default tags configuration
  # Think of tags as labels or stickers you put on all your cloud resources
  # These help you organize and track resources, similar to how you might label boxes when moving
  default_tags {
    tags = {
      Project = "VisitorBook"  # Identifies which project this resource belongs to
      Owner   = "DevOpsLearner"  # Identifies who is responsible for the resource
    }
  }
}

# Terraform Configuration Block
# This is like a "requirements.txt" for your infrastructure code
# It specifies which providers and versions you need, similar to how you'd specify
# which tools and versions you need for a construction project
terraform {
  required_providers {
    # AWS Provider Configuration
    # This tells Terraform to use the official AWS provider from HashiCorp
    # The version constraint (~> 4.0) means it will use any 4.x version
    # but not 5.0 or higher, ensuring compatibility
    aws = {
      source  = "hashicorp/aws"  # Official AWS provider from HashiCorp
      version = "~> 4.0"         # Version constraint: any 4.x version
    }
  }
}