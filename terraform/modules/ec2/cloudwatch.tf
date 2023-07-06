resource "aws_cloudwatch_log_group" "this" {
  name              = var.name
  retention_in_days = 30

  tags = {
    Name     = var.name
    Instance = var.name
  }
}
