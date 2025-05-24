# VPC and Networking Configuration
# This file defines our Virtual Private Cloud (VPC) and all networking components.
# Think of VPC as your private network in the cloud, similar to a private office building network.

# Create a VPC for our application
# This is like creating a private network space in AWS where all our resources will live
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"  # IP address range for our VPC (like a private network range)
  enable_dns_hostnames = true           # Allows resources to have DNS hostnames
  enable_dns_support   = true           # Enables DNS resolution within the VPC

  tags = {
    Name = "visitorbook-vpc"  # Name tag for easy identification
  }
}

# Create Internet Gateway
# This is like the main entrance/exit of our private network to the internet
# Similar to how a building needs a main entrance to connect to the outside world
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id  # Attaches the gateway to our VPC

  tags = {
    Name = "visitorbook-igw"  # Name tag for easy identification
  }
}

# Create a public subnet
# This is like a floor in our building that's accessible from the outside
# Resources here can be accessed from the internet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"  # IP range for this subnet
  availability_zone       = "us-east-1a"   # Physical location in AWS
  map_public_ip_on_launch = true          # Resources here get public IPs

  tags = {
    Name = "visitorbook-public-subnet"  # Name tag for easy identification
  }
}

# Create a private subnet
# This is like a secure floor in our building that's not directly accessible from outside
# Perfect for databases and other sensitive resources
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"  # IP range for this subnet
  availability_zone = "us-east-1b"   # Different AZ for redundancy

  tags = {
    Name = "visitorbook-private-subnet"  # Name tag for easy identification
  }
}

# Create a route table for the public subnet
# This is like a set of rules for how traffic should flow in our public area
# Similar to how you might have different rules for public vs private areas in a building
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # Route all internet traffic through the Internet Gateway
  # This is like saying "all traffic going to the internet should go through the main entrance"
  route {
    cidr_block = "0.0.0.0/0"  # All traffic
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "visitorbook-public-rt"  # Name tag for easy identification
  }
}

# Associate the public subnet with the public route table
# This is like applying the traffic rules to our public area
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Create security group for our EC2 instance
# This is like a set of rules for who can enter/exit our building and through which doors
# Similar to how a building might have different access rules for different entrances
resource "aws_security_group" "ec2" {
  name        = "visitorbook-ec2-sg"
  description = "Allow SSH, HTTP, and HTTPS traffic"
  vpc_id      = aws_vpc.main.id

  # Allow SSH traffic (port 22)
  # This is like allowing access through a specific door (SSH) for administration
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # For production, restrict to your IP
  }

  # Allow HTTP traffic (port 80)
  # This is like allowing access through the main entrance for web traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS traffic (port 443)
  # This is like allowing access through a secure entrance for encrypted web traffic
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  # This is like allowing people to leave the building through any exit
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "visitorbook-ec2-sg"  # Name tag for easy identification
  }
}