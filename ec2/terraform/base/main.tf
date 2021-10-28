terraform {
  required_version = "0.13.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket         = "demo-datacenter-tf-state-bucket"
    key            = "base/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "demo-datacenter-tf-state-locking-table"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "vpc" {
  tags = {
    "Name" = "Demo-Datacenter-VPC"
  }
}

data "aws_subnet_ids" "public_subnets_ids" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Tier = "Public"
  }
}

module "policy" {
  source = "./modules/policy"
}

module "ec2_servers" {
  source = "./modules/ec2-servers"

  vpc_id                     = data.aws_vpc.vpc.id
  vpc_subnets_ids            = data.aws_subnet_ids.public_subnets_ids.ids
  consul_cluster_name        = var.consul_cluster_name
  consul_cluster_server_size = var.consul_cluster_server_size
  public_subnets             = var.public_subnets
  instance_profile_name      = module.policy.instance_profile_name
}

module "ec2_clients" {
  source = "./modules/ec2-clients"

  vpc_id                     = data.aws_vpc.vpc.id
  vpc_subnets_ids            = data.aws_subnet_ids.public_subnets_ids.ids
  consul_cluster_name        = var.consul_cluster_name
  consul_clients             = var.consul_clients
  public_subnets             = var.public_subnets
  instance_profile_name      = module.policy.instance_profile_name
}

