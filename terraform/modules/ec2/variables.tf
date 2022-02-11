variable "name" {
  type        = string
  description = "A string to identify your EC2 instance and connected resources."
}


variable "ami" {
  type        = string
  description = "A valid AWS ami must be provided. e.g. ami-0653812935d0743fe."

  validation {
    condition     = can(regex("^ami-[0-9a-z]{8,17}$", var.ami))
    error_message = "You must provide a valid AWS ami_id. e.g. ami-0653812935d0743fe."
  }
}

variable "key_name" {
  type        = string
  description = "A valid Key Pair on AWS."
}

variable "instance_type" {
  type        = string
  description = "Specify an AWS instance type. e.g. t3.large."
}

variable "vpc_id" {
  type        = string
  description = "An AWS VPC id to deploy the instance. e.g. vpc-05c7f4537b71ede49"

  validation {
    condition     = can(regex("^vpc-[0-9a-z]{8,17}$", var.vpc_id))
    error_message = "You must provide a valid AWS VPC id. e.g. vpc-05c7f4537b71ede49."
  }
}

variable "subnet_id" {
  type        = string
  description = "An AWS Subnet id to deploy the instance. e.g. subnet-03bad5b8e444d8832."

  validation {
    condition     = can(regex("^subnet-[0-9a-z]{8,17}$", var.subnet_id))
    error_message = "You must provide a valid AWS Subnet id. e.g. subnet-03bad5b8e444d8832."
  }
}

variable "volume_size" {
  type    = number
  default = 8
}
