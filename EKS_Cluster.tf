terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


resource "aws_eks_cluster" "my_cluster" {
  name     = "my_cluster"
  role_arn = aws_iam_role.eks-iam-role.arn
  
  vpc_config {
    subnet_ids = ["<subnet_id_1>", "<subnet_id_2>"] 
  }

  depends_on = [
  aws_iam_role.eks-iam-role,
  ]

}

resource "aws_eks_node_group" "my_node_pool" {

  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "my-node-pool"
  node_role_arn   = aws_iam_role.eks-iam-role.arn

  subnet_ids = ["<subnet_id>"]

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 4
  }

  instance_types = ["t2.micro"]
  ami_type       = "AL2_x86_64"
  capacity_type  = "ON_DEMAND"
  disk_size      = 20

  depends_on = [
  aws_iam_role.eks-iam-role,
  ]

}
