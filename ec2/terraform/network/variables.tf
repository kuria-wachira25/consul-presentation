variable "cidr" {
  default     = "10.0.0.0/16"
  description = "Cidr block of vpc"
}

variable "public_subnets" {
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  description = "Cidr block of public subnets"
}

variable "availability_zones" {
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  description = "Availability zones for subnets"
}
