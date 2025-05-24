# ECR (Elastic Container Registry) Configuration
# This file sets up our Docker container registry in AWS.
# Think of ECR as a private warehouse for storing and managing Docker images,
# similar to how a warehouse stores and manages physical goods.

# Create a repository for the frontend application
# This is like creating a specific storage area for frontend containers
resource "aws_ecr_repository" "frontend" {
  name = "visitor-book-frontend"  # Name of the repository

  # Image scanning configuration
  # This is like having a security scanner for incoming packages
  image_scanning_configuration {
    scan_on_push = true  # Automatically scan images when pushed
  }

  # Image tag mutability
  # This is like deciding if you can overwrite existing versions
  image_tag_mutability = "MUTABLE"  # Allow overwriting tags

  tags = {
    Name = "visitor-book-frontend"
  }
}

# Create a repository for the backend application
# This is like creating a specific storage area for backend containers
resource "aws_ecr_repository" "backend" {
  name = "visitor-book-backend"  # Name of the repository

  # Image scanning configuration
  # This is like having a security scanner for incoming packages
  image_scanning_configuration {
    scan_on_push = true  # Automatically scan images when pushed
  }

  # Image tag mutability
  # This is like deciding if you can overwrite existing versions
  image_tag_mutability = "MUTABLE"  # Allow overwriting tags

  tags = {
    Name = "visitor-book-backend"
  }
}