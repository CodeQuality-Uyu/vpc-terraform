# Ya tenés data.aws_region.current definido; agregamos la AMI:
data "aws_ami" "al2023" {
  count       = var.enable_bastion_ssm ? 1 : 0
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"
    values = ["al2023-ami-*"]
  }
  filter {
    name = "architecture"
    values = [local.bastion_arch]
  } # x86_64 o arm64
}

resource "aws_instance" "bastion" {
  count                       = var.enable_bastion_ssm ? 1 : 0
  ami                         = data.aws_ami.al2023[0].id
  instance_type               = var.bastion_instance_type
  subnet_id                   = local.bastion_subnet_id                # PRIVADA
  vpc_security_group_ids      = [aws_security_group.bastion[0].id]
  iam_instance_profile        = aws_iam_instance_profile.bastion[0].name
  associate_public_ip_address = false
  hibernation                 = false

  metadata_options {
    http_tokens                 = "required" # IMDSv2
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
  }

  tags = merge(var.tags, {
    Name = "${var.name}-bastion"
  })
}
