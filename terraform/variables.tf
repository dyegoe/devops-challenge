variable "region" {
  type        = string
  description = "AWS region to deploy the resources. e.g. us-east-1."
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]{4,9}-[0-9]$", var.region))
    error_message = "You must provide a valid region name."
  }
}

variable "azs" {
  type        = list(string)
  description = "List of the availability zones to create the subnets."
  validation {
    condition     = length(var.azs) == 3
    error_message = "You must provide exactly 3 availability zones."
  }
}

variable "environment" {
  type        = string
  description = "An environment identifier. It is use for tagging."
  validation {
    condition     = can(regex("^[a-z0-9]{1,10}$", var.environment))
    error_message = "You must provide an environment name that contains only lowercase letters and numbers. Maximum of 10 chars."
  }
}

variable "project_name" {
  type        = string
  description = "A project name to use across the resources created using this terraform."
  validation {
    condition     = can(regex("^[a-z0-9-]{1,20}$", var.project_name))
    error_message = "You must provide a name that contains only lowercase letters, numbers and dashes (-). Maximum of 20 chars."
  }
}

variable "project_name_prefix" {
  type        = string
  description = "A short (5 chars) name to identify some resources."
  validation {
    condition     = can(regex("^[a-z0-9-]{1,4}-$", var.project_name_prefix))
    error_message = "You must provide a name that contains only lowercase letters, numbers and end with dash (-). Maximum of 5 chars."
  }
}

variable "vpc_cidr" {
  type = string
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "You must provide a valid CIDR block."
  }
  validation {
    condition     = cidrhost(var.vpc_cidr, 0) == split("/", var.vpc_cidr)[0]
    error_message = "You must provide a valid network address."
  }
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnets CIDR. It must be as many as the AZ quantity."
  validation {
    condition     = length(var.public_subnets) == 3
    error_message = "You must provide exactly 3 public subnets."
  }
  validation {
    condition     = alltrue([for subnet in var.public_subnets : can(cidrnetmask(subnet))])
    error_message = "You must provide valid CIDR blocks."
  }
  validation {
    condition     = alltrue([for subnet in var.public_subnets : cidrhost(subnet, 0) == split("/", subnet)[0]])
    error_message = "You must provide valid network addresses."
  }
}

variable "key_name" {
  type        = string
  description = "A key pair name previously created on AWS."
  validation {
    condition     = can(regex("^[a-z0-9-]{1,20}$", var.key_name))
    error_message = "You must provide a key name that contains only lowercase letters, numbers and dashes (-). Maximum of 20 chars."
  }
}

variable "instance_type" {
  type        = string
  description = "Specify an AWS instance type. e.g. t3.micro."
  validation {
    condition     = can(regex("^[a-z][a-z\\d]*\\d?[dnx]?\\.\\d*(nano|micro|small|medium|large|xlarge|[2-9]xlarge|metal)$", var.instance_type))
    error_message = "You must provide a valid instance type."
  }
}
