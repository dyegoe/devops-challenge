module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name                       = var.project_name
  vpc_id                     = module.vpc.vpc_id
  subnets                    = module.vpc.public_subnets
  enable_deletion_protection = false

  security_group_name = substr(format("%s-%s", var.project_name, replace(uuid(), "-", "")), 0, 32)
  security_group_tags = {
    Name = var.project_name
  }
  security_group_ingress_rules = {
    all_http = {
      description = "Allow HTTP from anywhere"
      from_port   = 80
      to_port     = 81
      ip_protocol = "TCP"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      description = "Allow all egress traffic"
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "instances"
      }
    }
  }

  target_groups = {
    instances = {
      name_prefix = var.project_name_prefix
      target_type = "instance"
      target_id   = module.ec2[0].instance_id
      protocol    = "HTTP"
      port        = 80
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  }

  additional_target_group_attachments = {
    for i in range(1, length(module.ec2)) : "instance-${i}" => {
      target_group_key = "instances"
      target_type      = "instance"
      target_id        = module.ec2[i].instance_id
      port             = 80
    }
  }

  depends_on = [module.ec2]
}

resource "aws_vpc_security_group_ingress_rule" "instance_alb_http" {
  count = length(module.ec2)

  security_group_id            = module.ec2[count.index].security_group_id
  description                  = "Allow HTTP from ALB"
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "TCP"
  referenced_security_group_id = module.alb.security_group_id

  tags = {
    Name = "${module.ec2[count.index].name}-http-alb-ingress"
  }
}
