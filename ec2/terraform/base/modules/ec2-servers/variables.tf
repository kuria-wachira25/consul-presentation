variable "consul_cluster_name" {
  type = string
  description = "Name of consul cluster to join"
}

variable "consul_cluster_server_size" {
  type = string
  description = "Number of consul servers in the consul cluster"
}

variable "vpc_subnets_ids" {
  type = list(string)
  description = "Subnets where the instances will be allocated"
}