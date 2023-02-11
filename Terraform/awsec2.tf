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
  module "elb" {
  source = "terraform-aws-modules/elb/aws"

  name = "my-elb"
  subnets = module.vpc.public_subnets

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

  health_check = {
    target = "HTTP:80/health"
    interval = 30
    timeout = 5
    healthy_threshold = 10
    unhealthy_threshold = 2
  }

  listener = [
    {
      instance_port     = 80
      instance_protocol = "HTTP"
      lb_port           = 80
      lb_protocol       = "HTTP"
    },
  ]

  target_group_attributes = [
    {
      key = "deregistration_delay.timeout_seconds"
      value = "20"
    },
  ]

  depends_on = [module.autoscaling_group.module_elb_target_group_arn]
  resource "aws_iam_access_key" "example" {
  user = "example-user"
}

}