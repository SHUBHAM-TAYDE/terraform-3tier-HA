variable "name" { type = string }
variable "region" { type = string }
variable "azs" { type = list(string) }
variable "vpc_cidr" { type = string }