# ---------- Gateway Endpoints ----------
locals {
  use_gateway_endpoints = var.enable_gateway_endpoints
}

resource "aws_vpc_endpoint" "s3" {
  count             = local.use_gateway_endpoints && var.enable_s3_gateway_endpoint ? 1 : 0
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [for rt in aws_route_table.private : rt.id]
  tags              = merge(var.tags, { Name = "${var.name}-vpce-s3" })
}

resource "aws_vpc_endpoint" "dynamodb" {
  count             = local.use_gateway_endpoints && var.enable_dynamodb_gateway_endpoint ? 1 : 0
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [for rt in aws_route_table.private : rt.id]
  tags              = merge(var.tags, { Name = "${var.name}-vpce-dynamodb" })
}

# ---------- Interface Endpoints ----------
resource "aws_security_group" "endpoints" {
  count       = var.enable_interface_endpoints ? 1 : 0
  name        = "${var.name}-vpce-sg"
  description = "SG for Interface VPC Endpoints"
  vpc_id      = aws_vpc.this.id
  tags        = merge(var.tags, { Name = "${var.name}-vpce-sg" })
}

# Permite HTTPS desde la VPC hacia los endpoints
resource "aws_vpc_security_group_ingress_rule" "vpce_https" {
  count             = var.enable_interface_endpoints ? 1 : 0
  security_group_id = aws_security_group.endpoints[0].id
  cidr_ipv4         = var.cidr_block
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "vpce_all" {
  count             = var.enable_interface_endpoints ? 1 : 0
  security_group_id = aws_security_group.endpoints[0].id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

locals {
  interface_services = {
    for svc in var.interface_endpoints :
    svc => "com.amazonaws.${data.aws_region.current.region}.${svc}"
  }
}

resource "aws_vpc_endpoint" "interface" {
  for_each = var.enable_interface_endpoints ? local.interface_services : {}

  vpc_id              = aws_vpc.this.id
  service_name        = each.value
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [for s in aws_subnet.private : s.id]
  security_group_ids  = [aws_security_group.endpoints[0].id]
  private_dns_enabled = true
  tags                = merge(var.tags, { Name = "${var.name}-vpce-${each.key}" })
}
