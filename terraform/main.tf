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

module "ec2" {
  count  = length(module.vpc.public_subnets)
  source = "./modules/ec2/"

  name          = "${var.project_name}-${count.index}"
  ami           = var.ami
  key_name      = var.key_name
  instance_type = var.instance_type
  vpc_id        = module.vpc.vpc_id
  subnet_id     = element(module.vpc.public_subnets, count.index)
}
