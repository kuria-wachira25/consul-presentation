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
    key            = "network/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "demo-datacenter-tf-state-locking-table"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Demo-Datacenter-VPC"
  }
}

resource "aws_eip" "eip_nat" {
  count = var.create_nat_per_subnet ? length(var.private_subnets) : 1
  vpc   = true
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)
  count             = length(var.private_subnets)

  tags = {
    Tier = "Private"
    Name = "Demo-Datacenter-VPC-Subnet-${element(var.availability_zones, count.index)}"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.create_nat_per_subnet ? length(var.private_subnets) : 1
  allocation_id = var.create_nat_per_subnet ? element(aws_eip.eip_nat.*.id, count.index) : element(aws_eip.eip_nat.*.id, 0)
  subnet_id     = var.create_nat_per_subnet ? element(aws_subnet.public_subnet.*.id, count.index) : element(aws_subnet.public_subnet.*.id, 0)
  depends_on    = [aws_eip.eip_nat, aws_subnet.private_subnet]
}


resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = true

  tags = {
    "Tier" = "Public"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table" "private_route_table" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "private_route" {
  count                  = length(compact(var.private_subnets))
  route_table_id         = element(aws_route_table.private_route_table.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.create_nat_per_subnet ? element(aws_nat_gateway.nat_gateway.*.id, count.index) : element(aws_nat_gateway.nat_gateway.*.id, 0)

  depends_on = [
    aws_route_table.private_route_table,
    aws_nat_gateway.nat_gateway
  ]
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private_route_table.*.id, count.index)
}