variable "aws_region"            { type = string }
variable "aws_access_key"        { type = string }
variable "aws_secret_key"        { type = string }

variable "name"            {
  description = "Nombre/prefijo para etiquetar recursos"
  type = string
}
variable "tags"            {
  description = "Tags comunes"
  type = map(string)
  default = {}
}

variable "cidr_block"      {
  description = "CIDR de la VPC"
  type = string
  default = "10.0.0.0/16"
}
variable "az_count"        {
  description = "Cantidad de AZs a usar"
  type = number
  default = 2
}
variable "azs"             {
  description = "Lista de AZs (opcional, si no se provee se detecta)"
  type = list(string)
  default = []
}

# Subnets: puedes pasar las CIDRs explícitas o dejar que se calculen
variable "public_subnet_cidrs"  {
  type = list(string)
  default = null
}
variable "private_subnet_cidrs" {
  type = list(string)
  default = null
}

# Cuando se calculan, se usan estos tamaños (cidrsubnet newbits)
variable "public_subnet_newbits"  {
  type = number
  default = 4
}   # /20 desde /16
variable "private_subnet_newbits" {
  type = number
  default = 4
}

variable "map_public_ip_on_launch" {
  type = bool
  default = true
}

# NAT
variable "enable_nat"         {
  type = bool
  default = true
}
variable "single_nat_gateway" {
  type = bool
  default = true
}  # true=1 NAT; false=NAT por AZ

# Endpoints
variable "enable_gateway_endpoints"   {
  type = bool
  default = true
}
variable "enable_s3_gateway_endpoint" {
  type = bool
  default = true
}
variable "enable_dynamodb_gateway_endpoint" {
  type = bool
  default = false
}

variable "enable_interface_endpoints" {
  type = bool
  default = true
}
# Lista de endpoints de interfaz a crear (puedes añadir/quitar)
variable "interface_endpoints" {
  type = list(string)
  default = [
    "ecr.api",
    "ecr.dkr",
    "logs",
    "ssm",
    "ec2messages",
    "ssmmessages",
    "secretsmanager"
  ]
}

variable "enable_bastion_ssm" {
  description = "Crea el bastion SSM dentro de la VPC"
  type        = bool
  default     = true
}

variable "bastion_instance_type" {
  description = "Tipo de instancia del bastion (t3.nano/t4g.nano)"
  type        = string
  default     = "t3.nano"
}

variable "bastion_subnet_id" {
  description = "Subnet PRIVADA para el bastion; si se omite, usa la primera privada"
  type        = string
  default     = ""
}

variable "enable_db_clients_sg" {
  description = "Crea SG compartido para workloads que consumen la DB"
  type        = bool
  default     = true
}

