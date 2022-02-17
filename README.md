# devops-challenge

The purpose of this repo is to deploy an environment to AWS.

- VPC.
- Public subnets across all specified availability zones.
- 1 EC2 instance on each public subnet.
- ALB serving port 80 of each instance.
- Deploy Nginx Docker container to each instance

## Premises

- Terraform installed. You can find more information [here](https://learn.hashicorp.com/tutorials/terraform/install-cli).
- Ansible installed. You can find mode information [here](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).
- Ansible AWS Plugin. `ansible-galaxy collection install amazon.aws`.
- Boto and Boto3 Python library.
- An AWS account with pragmatic access (access key id and secret access key). Information [here](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html).

## Modules

EC2 Module create by myself. You can find more about it [here](modules/ec2/README.md).

## Setup the environment

Setup your AWS access and secret keys into `~/.aws/credentials`.

```txt
mkdir -p ~/.aws
vi ~/.aws/credentials

[default]
aws_access_key_id = AKIAxxxxxxxxxxxxxxxx
aws_secret_access_key = 2zcixxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

[Create a SSH Key pair](https://docs.aws.amazon.com/ground-station/latest/ug/create-ec2-ssh-key-pair.html) in your AWS Console, take the downloaded `.pem` file and save it to `./ansible/`.
Make sure that the key name is the same as `var.key_name` in `./terraform/variables.tf` and `private_key_file` in `./ansible/ansible.cfg`.
After copying the file to `./ansible` directory, make sure that you reduce the privileges to the file

```txt
chmod 400 ansible/devops-challenge.pem
```

### Terraform

First of all, verify `variables.tf` and if it has the correct values that you are expecting for.

The variable `project_name` is used across Terraform to name the resources on AWS.

### Ansible

As mention in the premisses, make sure that you have the Ansible AWS plugin

```txt
ansible-galaxy collection install amazon.aws
```

This playbook uses AWS EC2 Inventory. It is a dynamic inventory. Edit inventory file `./ansible/inventory/aws_ec2.yaml` and match the region that you deployed Terraform infra.

```txt
plugin: aws_ec2
boto_profile: default
regions:
  - us-east-1
...
```

Edit `ansible/playbook.yaml` and match hosts as your `project_name` used on Terraform. NB! `-` dash is replaced by `_` underscore.

```txt
hosts: devops_challenge
```

Double check `ansible/ansible.cfg` if `remote_user` matches the default user for your AMI and if you will need `sudo` access. If you need, let `become = true`, otherwise, set it to false.

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
- [Ansible AWS EC2 inventory](https://docs.ansible.com/ansible/latest/collections/amazon/aws/aws_ec2_inventory.html).
- [Ansible.cfg reference](https://riptutorial.com/ansible/example/21992/ansible-cfg)
