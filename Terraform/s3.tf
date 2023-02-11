terraform {
  required_providers {
   aws = {
     source = "hashicorp/aws"
   }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket-terraform"
  acl    = "private"

  tags = {
    Name = "example-bucket"
  }
}

}