variable "consul_cluster_name" {
  default     = "demo-datacenter"
  description = "Name of consul cluster to join"
}

variable "consul_cluster_server_size" {
  default     = 3
  description = "Number of consul servers in the consul cluster"
}

variable "public_subnets" {
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  description = "Cidr block of public subnets"
}

variable "consul_clients" {
  type        = list(string)
  default     = [ "Counting-App", "Dashboard-App", "Httpd-App-1", "Httpd-App-2" ]
  description = "Client applications to create"
}