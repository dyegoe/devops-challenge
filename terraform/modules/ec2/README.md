# EC2 instance module

This module provides:

- EC2 Instance
- Security group that allows SSH access
- ElasticIP
- CloudWatch log group
- IAM Policy and instance profile that allows to write logs to CloudWatch.

## How to use

```hcl
module "ec2" {
  count  = length(module.vpc.public_subnets)
  source = "./modules/ec2/"

  name          = "${var.project_na-${count.ind"
  ami           = var.ami
  key_name      = var.key_name
  instance_type = var.instance_type
  vpc_id        = module.vpc.vpc_id
  subnet_id     = element(module.vpc.public_subnets, count.index
```

## Module variables

```txt
name: A name do be used across the resources created by terraform.
ami:  A valid AMI ID.
key_name: A key pair name created on AWS.
instance_type: A valid instance type on AWS.
vpc_id: VPC ID where the security group must be created.
subnet_id: Subnet ID where the EC2 instance should be created.
```

## Module outputs

```txt
instance_id: Instance ID. e.g. i-0eac781b680a8ae5c.

public_ip: The public IP associated to this instance.

public_ip_cidr: The public IP in CIDR notation. It is useful for security groups rules.

private_ip: The private IP associated to this instance.

private_ip_cidr: The private IP in CIDR notation. It is useful for security groups rules.

security_group_id: The security group ID which could be used to attach new rules outside this module. e.g. sg-0cfccd73797baa64d.

iam_role_name: The IAM role name which could be used to attach other policies outside this module.
```
