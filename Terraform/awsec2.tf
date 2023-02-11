terraform {
 required_providers {
   aws = {
     source = "hashicorp/aws"
   }
 }

provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "example-vpc"
  }
}

resource "aws_subnet" "example_a" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "example-subnet-a"
  }
}

resource "aws_subnet" "example_b" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "example-subnet-b"
  }
}

resource "aws_security_group" "example" {
  name        = "example-security-group"
  description = "Example security group for EC2 instance"

  ingress {
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

  vpc_id = aws_vpc.example.id
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.example.id]
  subnet_id     = aws_subnet.example_a.id

  tags = {
    Name = "example-instance-a"
  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "local-exec" {
    command = "echo Provisioning complete!"
  }

  block_device {
    device_name = "/dev/xvda"
    volume_type = "gp2"
    volume_size = 8
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "example_b" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.example.id]
  subnet_id     = aws_subnet.example_b.id

  tags = {
    Name = "example-instance-b"
  }

  root_block_device {
    volume_type = "standard"
    volume_size = 8
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_access_key" "example" {
  user = "example-user"
}
}