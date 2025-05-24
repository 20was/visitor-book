# EC2 (Elastic Compute Cloud) Configuration
# This file sets up our application servers in AWS.
# Think of EC2 as virtual computers in the cloud - like having a fleet of computers
# that you can start, stop, and configure as needed.

# Get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create IAM role for EC2 to access ECR
resource "aws_iam_role" "ec2_ecr_role" {
  name = "visitorbook-ec2-ecr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Attach policy to allow EC2 to access ECR
resource "aws_iam_role_policy_attachment" "ecr_policy" {
  role       = aws_iam_role.ec2_ecr_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECR-FullAccess"
}

# Create instance profile to attach role to EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "visitorbook-ec2-profile"
  role = aws_iam_role.ec2_ecr_role.name
}

# Create a security group for EC2 instances
# This is like having a security guard that controls who can access our servers
resource "aws_security_group" "ec2" {
  name        = "visitorbook-ec2-sg"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.main.id

  # Allow SSH access (port 22)
  # This is like having a secure entrance for administrators
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # For production, restrict to your IP
  }

  # Allow HTTP access (port 80)
  # This is like having a main entrance for web traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS access (port 443)
  # This is like having a secure entrance for encrypted web traffic
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  # This is like allowing the server to communicate with other services
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "visitorbook-ec2-sg"
  }
}

# Create EC2 instance
# This is like setting up a new computer with specific specifications
resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.ec2.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  
  # We'll need to create this key pair in the AWS console
  key_name               = "visitorbook-key"  # Create this in AWS console first!

  root_block_device {
    volume_size = 30  # GB
    volume_type = "gp2"
  }

  tags = {
    Name = "visitorbook-app-server"
  }
}