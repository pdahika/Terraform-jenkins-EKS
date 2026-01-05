variable "vpc_cidr" {
  description = "vpc_cidr"
  type        = string
}

variable "public_subnets" {
  description = "subnets_cidr"
  type        = list(string)
}

variable "instance_type" {
  description = "instance_type"
  type        = string
}