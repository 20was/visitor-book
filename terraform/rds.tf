# RDS (Relational Database Service) Configuration
# This file sets up our PostgreSQL database in AWS.
# Think of RDS as a managed database service - like having a professional database administrator
# who handles all the maintenance, backups, and security for you.

# Create a security group for RDS
# This is like having a security guard that only allows specific types of traffic to reach the database
resource "aws_security_group" "rds" {
  name        = "visitorbook-rds-sg"
  description = "Security group for RDS PostgreSQL"
  vpc_id      = aws_vpc.main.id

  # Allow PostgreSQL traffic from EC2 instances
  # This is like allowing only authorized staff to access the database room
  ingress {
    from_port       = 5432  # PostgreSQL default port
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]  # Only allow access from our EC2 instances
  }

  tags = {
    Name = "visitorbook-rds-sg"
  }
}

# Create a subnet group for RDS
# This is like choosing which floors in our building can host the database
# We use multiple subnets for high availability
resource "aws_db_subnet_group" "main" {
  name       = "visitorbook-db-subnet-group"
  subnet_ids = [aws_subnet.private.id]  # Place database in private subnet for security

  tags = {
    Name = "visitorbook-db-subnet-group"
  }
}

# Create the RDS instance
# This is like setting up a dedicated database server with specific requirements
resource "aws_db_instance" "main" {
  identifier           = "visitorbook-db"
  engine              = "postgres"
  engine_version      = "14.7"
  instance_class      = "db.t3.micro"  # Small instance for development
  allocated_storage   = 20  # 20 GB of storage
  storage_type        = "gp2"  # General Purpose SSD

  # Database credentials
  # These are like the keys to access the database
  username = var.db_username
  password = var.db_password

  # Network configuration
  # This is like choosing which security measures to put in place
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  publicly_accessible    = false  # Keep database private

  # Backup configuration
  # This is like having an automatic backup system
  backup_retention_period = 7  # Keep backups for 7 days
  backup_window          = "03:00-04:00"  # Backup during low-usage hours
  maintenance_window     = "Mon:04:00-Mon:05:00"  # Maintenance during low-usage hours

  # Additional settings
  multi_az               = false  # For production, set to true for high availability
  skip_final_snapshot    = true   # For development; set to false for production
  deletion_protection    = false  # For development; set to true for production

  tags = {
    Name = "visitorbook-db"
  }
}