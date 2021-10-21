variable "consul_cluster_name" {
    default = "demo-datacenter"
  description = "Name of consul cluster to join"
}

variable "consul_cluster_server_size" {
  default     = 3
  description = "Number of consul servers in the consul cluster"
}