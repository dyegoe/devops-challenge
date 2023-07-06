resource "aws_instance" "this" {
  ami                     = var.ami
  disable_api_termination = false
  ebs_optimized           = true
  instance_type           = var.instance_type
  subnet_id               = var.subnet_id
  key_name                = var.key_name
  monitoring              = true
  iam_instance_profile    = aws_iam_instance_profile.this.name
  vpc_security_group_ids = [
    aws_security_group.this.id
  ]
  credit_specification {
    cpu_credits = "unlimited"
  }
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = var.volume_size
    volume_type           = "gp2"
  }
  volume_tags = {
    "Name" = var.name
  }
  tags = {
    "Name" = var.name
  }
}

resource "aws_security_group" "this" {
  name        = substr(format("%s-%s", var.name, replace(uuid(), "-", "")), 0, 32)
  description = "Access related to ${var.name} EC2 instance"
  vpc_id      = var.vpc_id
  tags = {
    "Name" = var.name
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

resource "aws_security_group_rule" "this_all_ssh" {
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow SSH from anywhere"
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "this_all_egress" {
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all egress traffic"
  security_group_id = aws_security_group.this.id
}

resource "aws_eip" "this" {
  tags = {
    "Name" = var.name
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.this.id
  allocation_id = aws_eip.this.id
}

resource "aws_cloudwatch_log_group" "this" {
  name              = var.name
  retention_in_days = 30
}

resource "aws_iam_role" "this" {
  name                  = var.name
  force_detach_policies = true
  assume_role_policy    = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    "Name" = var.name
  }
}

resource "aws_iam_policy" "this" {
  name        = var.name
  path        = "/terraform/${var.name}/"
  description = "Terraform IAM policy created for ${var.name} EC2 instance"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeInstances"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_role_policy_attachment" "ec2_role_for_ssm" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_instance_profile" "this" {
  name = var.name
  role = aws_iam_role.this.name
}
