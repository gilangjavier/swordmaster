terraform {
 required_providers {
   aws = {
     source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_ecs_cluster" "my_cluster" {
  name = "my_cluster"
}

resource "aws_ecs_task_definition" "my_task" {
  family                = "service"
  container_definitions = file("task-definitions.json")

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"
  
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_ecs_service" "my_service" {
  name            = "my_service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.my_task.arn
  desired_count   = 5
  launch_type     = "FARGATE"

  network_configuration {
    assign_public_ip = true
    subnets          = ["subnet-abcd1234", "subnet-abcd5678"]
    security_groups  = ["sg-abcd1234", "sg-abcd5678"]
  }
}
