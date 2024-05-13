provider "aws" {
  region = "ap-south-1"
}

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1b" 
  map_public_ip_on_launch = true
}

# Create private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1a" 
}

# Internet Gateway for public subnet
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

/*# Attach the internet gateway to the VPC
resource "aws_internet_gateway_attachment" "my_igw_attachment" {
  vpc_id       = aws_vpc.my_vpc.id
  internet_gateway_id = aws_internet_gateway.my_igw.id
}*/

# Create a route table for public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

# Associate public subnet with public route table
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create a security group for public instance
resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.my_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a security group for private instance
resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.my_vpc.id
}

# Allow SSH access to public instance
resource "aws_security_group_rule" "public_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public_sg.id
}

# Allow SSH access from public instance to private instance
resource "aws_security_group_rule" "private_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.public_sg.id
  security_group_id        = aws_security_group.private_sg.id
}

# Launch EC2 instance in public subnet
resource "aws_instance" "public_instance" {
  ami           = "ami-013e83f579886baeb" # Replace with your desired AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.public_sg.id]
}

# Launch EC2 instance in private subnet
resource "aws_instance" "private_instance" {
  ami           = "ami-013e83f579886baeb" # Replace with your desired AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
}
