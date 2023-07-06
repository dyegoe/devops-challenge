module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = var.project_name

  load_balancer_type = "application"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [aws_security_group.alb.id]

  target_groups = [
    {
      name_prefix      = var.project_name_prefix
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets          = []
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]
}

resource "aws_lb_target_group_attachment" "instances" {
  count            = length(module.ec2)
  target_group_arn = module.alb.target_group_arns[0]
  target_id        = module.ec2[count.index].instance_id
  port             = 80
}

resource "aws_security_group" "alb" {
  name        = substr(format("%s-%s", var.project_name, replace(uuid(), "-", "")), 0, 32)
  description = "Access related to ${var.project_name} EC2 instance"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = var.project_name
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

resource "aws_vpc_security_group_egress_rule" "alb_all_egress" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow all egress traffic"
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${var.project_name}-alb-all-egress"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_all_http" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTP from anywhere"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "TCP"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "${var.project_name}-alb-http-all-ingress"
  }
}

resource "aws_vpc_security_group_ingress_rule" "instance_alb_http" {
  count = length(module.ec2)

  security_group_id            = aws_security_group.alb.id
  description                  = "Allow HTTP from ALB"
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "TCP"
  referenced_security_group_id = module.ec2[count.index].security_group_id

  tags = {
    Name = "${module.ec2[count.index].name}-http-alb-ingress"
  }
}
