variable "region" {
  type    = string
  default = "us-east-1"
}

variable "aws_access_key_id" {
  type = string
}
variable "aws_secret_access_key" {
  type = string
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "project_name" {
  type    = string
  default = "devops-challenge"
}

variable "vpc_cidr" {
  type    = string
  default = "10.161.0.0/24"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.161.0.0/26", "10.161.0.64/26", "10.161.0.128/26"]
}
