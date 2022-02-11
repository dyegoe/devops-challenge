region = "us-east-1"
azs = ["us-east-1a", "us-east-1b", "us-east-1c"]
environment = "dev"
# The variable `project_name` will be used across Terraform to name the resources on AWS.
project_name = "devops-challenge"
# Cannot be smaller than /24
vpc_cidr = "10.161.0.0/24"
# public_subnets must have as many cidr as the availability zones
public_subnets = ["10.161.0.0/26", "10.161.0.64/26", "10.161.0.128/26"]