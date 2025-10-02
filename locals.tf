data "aws_availability_zones" "available" { state = "available" }

locals {
  azs = length(var.azs) > 0 ? slice(var.azs, 0, var.az_count) : slice(data.aws_availability_zones.available.names, 0, var.az_count)

  # Si no pasas CIDRs, se calculan sin solaparse:
  # públicos: netnum [0..az_count-1]
  # privados: netnum [offset..offset+az_count-1], con offset = 2^(newbits-1)
  public_cidrs_computed = [
    for i in range(var.az_count) :
    cidrsubnet(var.cidr_block, var.public_subnet_newbits, i)
  ]

  private_offset         = pow(2, var.private_subnet_newbits - 1)
  private_cidrs_computed = [
    for i in range(var.az_count) :
    cidrsubnet(var.cidr_block, var.private_subnet_newbits, i + local.private_offset)
  ]

  public_cidrs  = coalesce(var.public_subnet_cidrs,  local.public_cidrs_computed)
  private_cidrs = coalesce(var.private_subnet_cidrs, local.private_cidrs_computed)


  # Toma la primera subnet privada si no se pasa una explícita
  bastion_subnet_id = var.bastion_subnet_id != "" ? var.bastion_subnet_id : values(aws_subnet.private)[0].id

  # Arquitectura: t4g.* => ARM; el resto x86_64
  bastion_is_arm = can(regex("^t4g\\.", var.bastion_instance_type))
  bastion_arch   = local.bastion_is_arm ? "arm64" : "x86_64"
}
