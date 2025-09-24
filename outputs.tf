output "vpc_id"    { value = aws_vpc.this.id }
output "vpc_cidr"  { value = aws_vpc.this.cidr_block }

output "public_subnet_ids"  { value = [for s in aws_subnet.public  : s.id] }
output "private_subnet_ids" { value = [for s in aws_subnet.private : s.id] }

output "public_route_table_id"  { value = aws_route_table.public.id }
output "private_route_table_ids" { value = [for rt in aws_route_table.private : rt.id] }

output "igw_id" { value = aws_internet_gateway.this.id }

output "nat_gateway_ids" {
  value = concat(
    var.enable_nat && var.single_nat_gateway ? [aws_nat_gateway.this[0].id] : [],
    var.enable_nat && !var.single_nat_gateway ? [for n in aws_nat_gateway.per_az : n.id] : []
  )
}
