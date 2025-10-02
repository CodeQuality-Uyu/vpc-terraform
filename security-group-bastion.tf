resource "aws_security_group" "bastion" {
  count       = var.enable_bastion_ssm ? 1 : 0
  name        = "${var.name}-bastion-sg"
  description = "SSM bastion (sin inbound; acceso solo por SSM)"
  vpc_id      = aws_vpc.this.id

  # Sin puertos abiertos desde afuera; solo salida (NAT o VPC endpoints)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-bastion-sg"
  })
}
