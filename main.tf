#My CI/CD
variable "instances" {
  type    = list(any)
  default = ["0"]
}
#Provider data
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
# VPC
resource "aws_vpc" "self" {
  cidr_block           = "10.9.0.0/16"
  enable_dns_support   = true #gives you an internal domain name
  enable_dns_hostnames = true #gives you an internal host name
  instance_tenancy     = "default"
  tags = {
    Name = "vpc-sh"
  }
}
#Subnet
resource "aws_subnet" "self" {
  vpc_id                  = aws_vpc.self.id
  cidr_block              = "10.9.0.0/24"
  map_public_ip_on_launch = false
  tags = {
    Name = "subnet-sh"
  }
}
#Internet Gateway
resource "aws_internet_gateway" "self" {
  vpc_id = aws_vpc.self.id
  tags = {
    Name = "ig-sh"
  }
}
#Custom Route Table
resource "aws_route_table" "self" {
  vpc_id = aws_vpc.self.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.self.id
  }

  tags = {
    Name = "crt-sh"
  }
}
#Associate CRT with Subnet
resource "aws_route_table_association" "self" {
  subnet_id      = aws_subnet.self.id
  route_table_id = aws_route_table.self.id
}
#Security Group
resource "aws_security_group" "self" {
  vpc_id      = aws_vpc.self.id
  description = "CICD Security Group"
  ingress { #Accepts all from the self Subnet
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.9.0.0/24"]
  }
  ingress {#Accepts all TCP connections from internet on the specificed ports
    from_port   = 4442
    to_port     = 4444
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress { #SSH Connection from anywhere
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sh"
  }
}

#EC2 instance
resource "aws_instance" "self" {
  for_each                    = toset(var.instances)
  associate_public_ip_address = "true"
  ami                         = var.ec2_ami
  instance_type               = var.ec2_instance_type
  key_name                    = var.ec2_key_name #Uses an existing key
  subnet_id                   = aws_subnet.self.id
  vpc_security_group_ids      = [aws_security_group.self.id]
  source_dest_check           = false
  user_data                   = "${file("init.sh")}"
  root_block_device {
    volume_type = "gp2"
    volume_size = 40
    encrypted   = true
  }
  tags = {
    Name = "selenium-hub-instance"
  }
}
