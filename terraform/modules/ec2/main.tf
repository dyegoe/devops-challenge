resource "aws_instance" "this" {
  ami                     = var.ami
  disable_api_termination = false
  ebs_optimized           = true
  instance_type           = var.instance_type
  key_name                = var.key_name
  monitoring              = false
  iam_instance_profile    = aws_iam_instance_profile.this.name

  metadata_options {
    http_endpoint          = "enabled"
    http_tokens            = "required"
    instance_metadata_tags = "enabled"
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = var.volume_size
    volume_type           = "gp3"
    tags = {
      Name     = "${var.name}-root"
      Instance = var.name
    }
  }

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.this.id
  }

  tags = {
    Name = var.name
  }

  depends_on = [
    aws_eip.this,
    aws_eip_association.this,
    aws_network_interface.this
  ]
}
