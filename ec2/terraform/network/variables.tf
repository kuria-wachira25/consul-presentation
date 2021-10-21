variable "cidr" {
  default     = "10.0.0.0/16"
  description = "Cidr block of vpc"
}

variable "public_subnets" {
  default     = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
  description = "Cidr block of public subnets"
}

variable "private_subnets" {
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  description = "Cidr block of private subnets"
}

variable "availability_zones" {
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  description = "Availability zones for subnets"
}

variable "create_nat_per_subnet" {
  default     = false
  description = "Choose whether to create a nat gateway per private subnet for higher availability"
}
