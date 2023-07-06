resource "aws_eip" "this" {
  tags = {
    Name     = var.name
    Instance = var.name
  }
}

resource "aws_eip_association" "this" {
  network_interface_id = aws_network_interface.this.id
  allocation_id        = aws_eip.this.id

  depends_on = [
    aws_eip.this,
    aws_network_interface.this
  ]
}
