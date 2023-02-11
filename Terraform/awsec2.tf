terraform {
 required_providers {
   aws = {
     source = "hashicorp/aws"
   }
 }

provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name           = "my-ec2-instance"
  ami            = "ami-0c55b159cbfafe1f0"
  instance_type  = "t2.micro"
  vpc_security_group_ids = [module.vpc.default_security_group_id]

  subnet_id = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "autoscaling_group" {
  source = "terraform-aws-modules/autoscaling/aws"

  name            = "my-asg"
  max_size        = 5
  min_size        = 1
  desired_capacity = 2

  launch_template = {
    id = aws_launch_template.ec2.id
  }

  vpc_zone_identifier = [module.vpc.public_subnets[0]]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_launch_template" "ec2" {
  name = "my-launch-template"

  image_id = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  security_group_ids = [module.vpc.default_security_group_id]

  block_device_mappings = [
    {
      device_name = "/dev/xvda"
      ebs = {
        volume_size = 8
      }
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
  provisioner "local-exec" {
    command = "echo Provisioning complete!"
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
