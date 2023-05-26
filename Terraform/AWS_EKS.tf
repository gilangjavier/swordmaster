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

data "aws_availability_zones" "available" {}

resource "aws_iam_user" "eks_user" {
  name = "eksUser"
  path = "/"
}

resource "aws_iam_access_key" "eks_user_key" {
  user = aws_iam_user.eks_user.name
}

resource "aws_iam_user_policy_attachment" "eks_user_attach" {
  user       = aws_iam_user.eks_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_user_policy_attachment" "eks_cni_policy" {
  user       = aws_iam_user.eks_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_user_policy_attachment" "eks_full_access" {
  user       = aws_iam_user.eks_user.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFullAccess"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-cluster"
  cluster_version = "1.27"
  subnets         = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]
  vpc_id          = "vpc-abcde012"

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      instance_type = "m5.large"
      key_name      = "my-key"

      root_volume_size = 10
      root_volume_type = "gp2"

      k8s_labels = {
        Environment = "test"
        Name        = "eksNode"
      }
    }
  }

  map_roles = [
    {
      rolearn  = "arn:aws:iam::${var.account_id}:role/EksEbsCsiDriver"
      username = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
      groups   = ["system:masters"]
    }
  ]

  map_users = [
    {
      userarn  = aws_iam_user.eks_user.arn
      username = aws_iam_user.eks_user.name
      group    = "system:masters"
    }
  ]
}

resource "kubernetes_service_account" "ebs_csi_controller_sa" {
  metadata {
    name      = "ebs-csi-controller-sa"
    namespace = "kube-system"

    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::${var.account_id}:role/EksEbsCsiDriver"
    }
  }
}

resource "null_resource" "install_ebs_csi_driver" {
  depends_on = [module.eks, kubernetes_service_account.ebs_csi_controller_sa]

  provisioner "local-exec" {
    command = <<-EOH
      kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/ecr/?ref=master"
    EOH
  }
}
