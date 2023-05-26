
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

resource "aws_lambda_function" "test_lambda" {
  function_name = "test_lambda"

  filename      = "test_lambda.zip"
  source_code_hash = filebase64sha256("test_lambda.zip")
  handler       = "index.handler"
  role          = aws_iam_role.lambda_exec.arn
  runtime       = "python3.8"
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"
  
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
