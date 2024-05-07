output "alb_url" {
  value = "http://${module.alb.dns_name}"
}

output "instances_ips" {
  value = {
    for instance in module.ec2 : instance.name => instance.public_ip
  }
}
