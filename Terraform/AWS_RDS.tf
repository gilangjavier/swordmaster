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

resource "aws_db_instance" "default" {
  allocated_storage    = 100
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.m5.large"
  name                 = "my_production_db"
  username             = "admin_user"
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  publicly_accessible  = false
  multi_az             = true
  backup_retention_period = 30
  backup_window         = "04:00-06:00"
  maintenance_window   = "Mon:00:00-Mon:03:00"
  skip_final_snapshot  = false
  final_snapshot_identifier = "final-snapshot-${self.name}"
}

variable "db_password" {
  description = "The password of the RDS instance"
  sensitive = true
}
