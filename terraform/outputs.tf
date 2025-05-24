# Outputs Configuration
# This file defines what information we want to see after Terraform runs.
# Think of outputs as the "receipt" or "summary" of what was created,
# showing important information we might need later.

# Output the VPC ID
# This is like getting the address of the building we just created
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

# Output the public subnet IDs
# This is like getting the floor numbers of the public areas
output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

# Output the private subnet IDs
# This is like getting the floor numbers of the private areas
output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

# Output the RDS endpoint
# This is like getting the address of the database server
output "rds_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.main.endpoint
}

# Output the EC2 instance public IP
# This is like getting the public address of our application server
output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}

# Output the ECR repository URLs
# This is like getting the addresses of our container warehouses
output "ecr_repository_urls" {
  description = "The URLs of the ECR repositories"
  value = {
    frontend = aws_ecr_repository.frontend.repository_url
    backend  = aws_ecr_repository.backend.repository_url
  }
}