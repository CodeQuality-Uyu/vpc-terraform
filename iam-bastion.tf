resource "aws_iam_role" "bastion_ssm_role" {
  count              = var.enable_bastion_ssm ? 1 : 0
  name               = "${var.name}-bastion-ssm-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action   = "sts:AssumeRole"
    }]
  })
  tags = merge(var.tags, {})
}

resource "aws_iam_role_policy_attachment" "bastion_ssm_core" {
  count      = var.enable_bastion_ssm ? 1 : 0
  role       = aws_iam_role.bastion_ssm_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "bastion" {
  count = var.enable_bastion_ssm ? 1 : 0
  name  = "${var.name}-bastion-profile"
  role  = aws_iam_role.bastion_ssm_role[0].name
}
