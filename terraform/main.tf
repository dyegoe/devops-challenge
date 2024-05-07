provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Terraform   = "true"
      Environment = var.environment
      Project     = var.project_name
    }
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.project_name
  cidr = var.vpc_cidr

  azs            = var.azs
  public_subnets = var.public_subnets
}

data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

module "ec2" {
  count  = length(module.vpc.public_subnets)
  source = "./modules/ec2/"

  name          = "${var.project_name}-${count.index}"
  ami           = data.aws_ssm_parameter.al2023.value
  key_name      = var.key_name
  instance_type = var.instance_type
  vpc_id        = module.vpc.vpc_id
  subnet_id     = element(module.vpc.public_subnets, count.index)
  depends_on    = [module.vpc]
}
