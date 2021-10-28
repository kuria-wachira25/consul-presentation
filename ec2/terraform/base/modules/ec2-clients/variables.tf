variable "consul_cluster_name" {
  type        = string
  description = "Name of consul cluster to join"
}

variable "vpc_subnets_ids" {
  type        = list(string)
  description = "Subnets where the instances will be allocated"
}

variable "vpc_id" {
  type        = string
  description = "ID of vpc"
}

variable "public_subnets" {
  type        = list(string)
  description = "Cidr block of public subnets"
}

variable "instance_profile_name" {
  type        = string
  description = "Profile to use to enable retry rejoin using ec2 tags"
}

variable "consul_clients" {
  type        = list(string)
  description = "Client Applications"
}