variable "region" {
  type    = string
  default = "us-east-1"
}

variable "azs" {
  type        = list(string)
  description = "List of the availability zones to create the subnets."
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "environment" {
  type        = string
  description = "An environment identifier. It is use for tagging."
  default     = "dev"
}

variable "project_name" {
  type        = string
  description = "A project name to use across the resources created using this terraform."
  default     = "devops-challenge"
}

variable "project_name_prefix" {
  type        = string
  description = "A short (5 chars) name to identify some resources."
  default     = "dvoc-"

  validation {
    condition     = can(regex("^[a-z0-9-]{1,5}$", var.project_name_prefix))
    error_message = "You must provide a name that contains only lowercase letters, numbers and dash (-). Maximum of 5 chars."
  }
}

variable "vpc_cidr" {
  type    = string
  default = "10.161.0.0/24"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnets CIDR. It must be as many as the AZ quantity."
  default     = ["10.161.0.0/26", "10.161.0.64/26", "10.161.0.128/26"]
}

variable "ami" {
  type    = string
  default = "ami-033b95fb8079dc481"
}

variable "key_name" {
  type        = string
  description = "A key pair name previously created on AWS."
  default     = "devops-challenge"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}
