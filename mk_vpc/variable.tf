variable "vpc_cidr" {
  default = "10.162.0.0/16"
}
variable "public_subnets_cidr" {
  description = "4 public subnets CIDR Blocks"
  default     = ["10.162.0.0/20", "10.162.16.0/20", "10.162.32.0/20", "10.162.48.0/20"]
}

variable "private_subnets_cidr" {
  description = "4 private subnets CIDR Blocks"
  default     = ["10.162.64.0/20", "10.162.80.0/20", "10.162.96.0/20", "10.162.112.0/20"]
}

variable "security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = "terraform-sg-web"
}
