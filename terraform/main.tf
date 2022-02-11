provider "aws" {
  region     = var.region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
  default_tags {
    tags = {
      Terraform   = "true"
      Environment = var.environment
      Project     = var.project_name
    }
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.project_name
  cidr = var.vpc_cidr

  azs            = var.azs
  public_subnets = var.public_subnets
}
