output "instance_id" {
  value       = aws_instance.this.id
  description = "Instance ID. e.g. i-0eac781b680a8ae5c."
}

output "public_ip" {
  value       = aws_instance.this.public_ip
  description = "The public IP associated to this instance. It is different from the EIP, because Elastic IP will be associated later on."
}

output "public_ip_cidr" {
  value       = "${aws_instance.this.public_ip}/32"
  description = "The public IP in CIDR notation. It could be used in the security group rules."
}

output "private_ip" {
  value       = aws_instance.this.private_ip
  description = "The private IP associated to this instance."
}

output "private_ip_cidr" {
  value       = "${aws_instance.this.private_ip}/32"
  description = "The private IP in CIDR notation. It could be used in the security group rules."
}

output "security_group_id" {
  value       = aws_security_group.this.id
  description = "The security group ID which could be used to attach new rules outside this module. e.g. sg-0cfccd73797baa64d."
}

output "iam_role_name" {
  value       = aws_iam_role.this.name
  description = "The IAM role name which could be used to attach other policies outside this module."
}
