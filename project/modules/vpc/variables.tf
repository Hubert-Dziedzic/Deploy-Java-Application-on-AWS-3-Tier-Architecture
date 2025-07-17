variable "name" {
  description = "Name prefix for VPC resource"
  type = string
}

variable "cidr_block" {
  description = "CIDR block for VPC"
  type = string
}

variable "availability _zones" {
  description = "List of AZs"
  type = list(string)
}

variable "public_subnets_cidrs" {
  description = "CIDR blocks for public subnets"
  type = list(string)
}

variable "private_subnets_cidrs" {
  description = "CIDR blocks for private subnets"
  type = list(string)
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type = bool
  default = true
}

variable "enable_vpn_gateway" {
  description = "Enable VPN Gateway"
  type = bool
  default = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type = map(string)
  default = {}
}