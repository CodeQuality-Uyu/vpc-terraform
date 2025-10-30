# 🏗️ VPC Base Module — EColors Platform

Este módulo crea la red base (VPC) utilizada por los entornos de **EColors**  
para hospedar servicios ECS, RDS y ALB en subnets privadas y públicas.

---

## 🚀 Recursos creados

### Red y Routing
- **VPC** con DNS y hostnames habilitados.
- **Subnets públicas** (para ALB / NAT Gateway).
- **Subnets privadas** (para ECS y RDS).
- **Internet Gateway (IGW)**.
- **Route Tables**:
  - Públicas → salida directa a IGW.
  - Privadas → salida vía NAT Gateway (configurable).

### NAT Gateways
- `enable_nat = true` → habilita NAT.
- `single_nat_gateway = true` → modo **budget** (1 NAT total).
- `single_nat_gateway = false` → modo **HA** (1 NAT por AZ).

### VPC Endpoints (Privados)
- **Gateway Endpoints**:
  - S3 ✅
  - DynamoDB (opcional)
- **Interface Endpoints**:
  - ECR (api/dkr)
  - CloudWatch Logs
  - SSM, EC2 Messages, SSM Messages
  - Secrets Manager

> 🔒 Esto permite que ECS, SSM y RDS funcionen sin depender del NAT Gateway.

### Bastion (opcional)
- Instancia EC2 privada con acceso **solo por SSM** (sin SSH).
- AMI Amazon Linux 2023 (auto x86/ARM).
- Permite acceder a la VPC internamente (ej. para depurar RDS).

### Security Groups
- `db_clients_sg`: SG compartido para workloads que acceden a la base de datos.
- `bastion_sg`: SG para bastion sin inbound.
- `endpoints_sg`: SG asociado a endpoints interface.

---

## 💾 Outputs principales

| Output | Descripción |
|--------|--------------|
| `vpc_id` | ID de la VPC |
| `vpc_cidr` | Rango CIDR de la VPC |
| `public_subnet_ids` | IDs de subnets públicas |
| `private_subnet_ids` | IDs de subnets privadas |
| `nat_gateway_ids` | IDs de NAT gateways creados |
| `db_clients_sg_id` | SG compartido para clientes de RDS |
| `ssm_bastion_sg_id` | SG del bastion SSM |
| `bastion_instance_id` | ID de la instancia bastion |
| `public_route_table_id` | Route table pública |
| `private_route_table_ids` | Route tables privadas |

---

## 🧠 Recomendaciones

- Para **nonprod (dev / qa)**:
  ```hcl
  enable_nat         = true
  single_nat_gateway = true
  enable_bastion_ssm = true
  az_count           = 2
  ```
- Para **prod o tenants dedicados**:
```hcl
  enable_nat         = true
  single_nat_gateway = false
  enable_bastion_ssm = false
  az_count           = 3
```
