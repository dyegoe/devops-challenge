output "alb_url" {
  value = "http://${module.alb.lb_dns_name}"
}

output "instances_ips" {
  value = module.ec2[*].public_ip
}
