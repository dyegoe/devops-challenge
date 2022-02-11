# devops-challenge

The purpose of this repo is to deploy an environment to AWS.

- VPC.
- Public subnets across all specified availability zones.
- 1 EC2 instance on each public subnet.
- ALB serving port 80 of each instance.
- Deploy Nginx Docker container to each instance

## Premises

- Terraform installed. You can find more information [here](https://learn.hashicorp.com/tutorials/terraform/install-cli).
- An AWS account with pragmatic access (access key id and secret access key). Information [here](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html).

## Modules

EC2 Module create by myself. You can find more about it [here](modules/ec2/README.md).

## Setup the environment

First of all, verify `variables.tf` and if it has the correct values that you are expecting for.

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

- [Terraform AWS VPC Module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest).
- [Terraform AWS ALB Module](https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/latest).
- [Terraform AWS Provider default tags](https://www.hashicorp.com/blog/default-tags-in-the-terraform-aws-provider).
- [Terraform AWS LB target group attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment).
- [Terraform length](https://www.terraform.io/language/functions/length)
- [Terraform count](https://www.terraform.io/language/meta-arguments/count)
- [Terraform custom validation rule](https://www.terraform.io/language/values/variables#custom-validation-rules)
