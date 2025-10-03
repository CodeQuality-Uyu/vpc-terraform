resource "aws_security_group" "db_clients" {
  count       = var.enable_db_clients_sg ? 1 : 0
  name        = "${var.name}-db-clients-sg"
  description = "Shared SG for apps that connect to RDS (attach to ECS tasks)"
  vpc_id      = aws_vpc.this.id

  # sin inbound; solo salida (las tasks inician la conexión)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name}-db-clients-sg" })
}
