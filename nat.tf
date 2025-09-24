# EIP(s) para NAT
resource "aws_eip" "nat" {
  count      = var.enable_nat ? (var.single_nat_gateway ? 1 : var.az_count) : 0
  domain     = "vpc"
  depends_on = [aws_internet_gateway.this]
  tags       = merge(var.tags, { Name = "${var.name}-nat-eip-${count.index}" })
}

# NAT único (budget) en la 1ra subnet pública
resource "aws_nat_gateway" "this" {
  count         = var.enable_nat && var.single_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = values(aws_subnet.public)[0].id
  tags          = merge(var.tags, { Name = "${var.name}-natgw" })
}

# NAT por AZ (HA, más costo)
resource "aws_nat_gateway" "per_az" {
  for_each      = var.enable_nat && !var.single_nat_gateway ? aws_subnet.public : {}
  allocation_id = aws_eip.nat[tonumber(each.key)].id
  subnet_id     = each.value.id
  tags          = merge(var.tags, { Name = "${var.name}-natgw-${each.value.availability_zone}" })
}
