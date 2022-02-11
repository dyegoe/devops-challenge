# devops-challenge

The purpose of this repo is to deploy an environment to AWS.

- VPC.
- Public subnets across all specified availability zones.
- 1 EC2 instance on each public subnet.
- ALB serving port 80 of each instance.

## Premises

- Terraform installed. You can find more information [here](https://learn.hashicorp.com/tutorials/terraform/install-cli).
- An AWS account with pragmatic access (access key id and secret access key). Information [here](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html).

## Setup the environment

First of all, verify `terraform.tfvars` and if it has the correct values that you are expecting. e.g.

```conf
region = "us-east-1"
azs = ["us-east-1a", "us-east-1b", "us-east-1c"]
environment = "dev"
project_name = "devops-challenge"
vpc_cidr = "10.161.0.0/24"
public_subnets = ["10.161.0.0/26", "10.161.0.64/26", "10.161.0.128/26"]
```

The variable `project_name` will be used across Terraform to name the resources on AWS.

Setup your AWS access and secret keys into `secure.auto.tfvars`. This file will not be pushed to the repo as it belongs to `.gitignore`.

```txt
echo 'aws_access_key_id = \"xxxxxxxx"' > secure.auto.tfvars
echo 'aws_secret_access_key = xxxxxxxxxxxxxxxx' >> secure.auto.tfvars
```

## Apply terraform

```txt
terraform init
terraform plan -out dev.plan
terraform apply dev.plan
```

## References

- [AWS VPC Module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest).
- [AWS Provider default tags](https://www.hashicorp.com/blog/default-tags-in-the-terraform-aws-provider).
