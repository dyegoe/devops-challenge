resource "aws_network_interface" "this" {
  subnet_id       = var.subnet_id
  security_groups = [aws_security_group.this.id]

  tags = {
    Name     = "${var.name}-eth0"
    Instance = var.name
  }

  depends_on = [
    aws_security_group.this
  ]
}
