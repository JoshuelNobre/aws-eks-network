variable "project_name" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_cidr" {
  type    = string
  default = "CIDR principal da VPC"
}

variable "vpc_additional_cidrs" {
  type        = list(string)
  description = "Lista de CIDR's adicionais da VPC"
  default     = []
}

variable "public_subnets" {
  description = "Lista de Public Subnets da VPC"
  type = list(object({
    name              = string
    cidr              = string
    availability_zone = string
  }))
}