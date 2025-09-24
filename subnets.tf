# Subnets públicas (1 por AZ)
resource "aws_subnet" "public" {
  for_each = { for idx, az in local.azs : idx => { idx = idx, az = az, cidr = local.public_cidrs[idx] } }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    var.tags,
    { Name = "${var.name}-public-${each.value.az}", "Tier" = "public" }
  )
}

# Subnets privadas (1 por AZ)
resource "aws_subnet" "private" {
  for_each = { for idx, az in local.azs : idx => { idx = idx, az = az, cidr = local.private_cidrs[idx] } }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(
    var.tags,
    { Name = "${var.name}-private-${each.value.az}", "Tier" = "private" }
  )
}
