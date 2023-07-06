resource "aws_security_group" "this" {
  name        = substr(format("%s-%s", var.name, replace(uuid(), "-", "")), 0, 32)
  description = "Access related to ${var.name} EC2 instance"
  vpc_id      = var.vpc_id

  tags = {
    Name = var.name
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

resource "aws_vpc_security_group_egress_rule" "this_all_egress" {
  security_group_id = aws_security_group.this.id
  description       = "Allow all egress traffic"
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name     = "${var.name}-all-egress"
    Instance = var.name
  }
}

resource "aws_vpc_security_group_ingress_rule" "this_all_ingress" {
  security_group_id = aws_security_group.this.id
  description       = "Allow SSH from anywhere"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "TCP"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name     = "${var.name}-ssh-all-ingress"
    Instance = var.name
  }
}
