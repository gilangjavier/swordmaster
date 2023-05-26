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

resource "aws_s3_bucket" "bucket" {
  bucket = "my-example-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_iam_user" "user" {
  name = "my-example-user"
  path = "/"
}

resource "aws_iam_access_key" "user" {
  user = aws_iam_user.user.name
}

resource "aws_iam_user_policy" "user" {
  name = "my-example-policy"
  user = aws_iam_user.user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:ListBucket"]
        Effect   = "Allow"
        Resource = [aws_s3_bucket.bucket.arn]
      },
      {
        Action   = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"]
        Effect   = "Allow"
        Resource = ["${aws_s3_bucket.bucket.arn}/*"]
      },
    ]
  })
}

output "access_key" {
  value = aws_iam_access_key.user.id
}

output "secret_access_key" {
  value = aws_iam_access_key.user.secret
}
