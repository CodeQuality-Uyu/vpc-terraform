# network (VPC base)

Crea:
- **VPC** con DNS habilitado
- **Subnets públicas** (para ALB) y **privadas** (para ECS/RDS)
- **Route tables** + **IGW** y (opcional) **NAT** (modo budget: 1 NAT; o 1 por AZ)
- **VPC Endpoints**
  - Gateway: **S3** (y opcional **DynamoDB**)
  - Interface: **ECR (api/dkr)**, **CloudWatch Logs**, **SSM** (+ **EC2 Messages**, **SSM Messages**), **Secrets Manager**
- *Outputs* que consumen `ingress-*`, `ecs-service`, `rds-shared`

> Presupuestario por defecto: **1 NAT** (`single_nat_gateway = true`).  
> Puedes desactivar NAT con `enable_nat = false` y apoyarte en endpoints para tráfico privado.

## Outputs clave
- `vpc_id`, `vpc_cidr`
- `public_subnet_ids`, `private_subnet_ids`
- `public_route_table_id`, `private_route_table_ids`
- `igw_id`, `nat_gateway_ids`
