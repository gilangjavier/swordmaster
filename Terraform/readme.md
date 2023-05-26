# Terraform AWS Deployment Scripts

This repository contains a collection of Terraform scripts for managing resources on Amazon Web Services (AWS).

## Overview

The scripts are designed to automate the setup and management of various AWS resources including:

- AWS EC2 instances
- AWS RDS (Relational Database Service)
- AWS S3 Buckets
- AWS EKS (Elastic Kubernetes Service)
- AWS Lambda functions
- AWS ECR (Elastic Container Registry)
- AWS ECS (Elastic Container Service)

## Prerequisites

- You will need to have Terraform installed. You can download Terraform from [here](https://www.terraform.io/downloads.html).
- An AWS account and your AWS credentials need to be set up on your machine. This can be done by installing the AWS CLI and running `aws configure`.

## Usage

1. Clone this repository:

```
git clone https://github.com/gilangjavier/swordmaster.git
cd terraform-aws-scripts
```

2. Initialize Terraform for your project:

```
terraform init
```

3. Create a Terraform plan:

```
terraform plan
```

4. Apply the Terraform plan:

```
terraform apply
```

Please navigate to each respective directory to find more details about each script.

## Note

These scripts are for illustrative purposes and should be customized for production environments. Please ensure that you understand the effects of these scripts before running them, especially in a production environment.
