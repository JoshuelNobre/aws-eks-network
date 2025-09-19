# Infraestrutura de Rede AWS para EKS

Este repositório contém a infraestrutura como código (IaC) para configuração de rede na AWS, otimizada para clusters Amazon EKS (Elastic Kubernetes Service).

## 🏗️ Arquitetura

### VPC e CIDRs
- **VPC Principal**: `10.0.0.0/16`
- **CIDR Adicional**: `100.64.0.0/16` (para pods Kubernetes)

### Subnets

#### 🌐 Subnets Públicas
| Nome | CIDR | Availability Zone |
|------|------|------------------|
| linuxtips-public-1a | 10.0.48.0/24 | us-east-1a |
| linuxtips-public-1b | 10.0.49.0/24 | us-east-1b |
| linuxtips-public-1c | 10.0.50.0/24 | us-east-1c |

**Uso**: NAT Gateways, Load Balancers

#### 🔒 Subnets Privadas (Nodes)
| Nome | CIDR | Availability Zone |
|------|------|------------------|
| linuxtips-private-1a | 10.0.0.0/20 | us-east-1a |
| linuxtips-private-1b | 10.0.16.0/20 | us-east-1b |
| linuxtips-private-1c | 10.0.32.0/20 | us-east-1c |

**Uso**: Nodes EKS (EC2)

#### 🔄 Subnets Privadas (Pods)
| Nome | CIDR | Availability Zone |
|------|------|------------------|
| linuxtips-pods-1a | 100.64.0.0/18 | us-east-1a |
| linuxtips-pods-1b | 100.64.64.0/18 | us-east-1b |
| linuxtips-pods-1c | 100.64.128.0/18 | us-east-1c |

**Uso**: Pods Kubernetes

#### 💾 Subnets Database
| Nome | CIDR | Availability Zone |
|------|------|------------------|
| linuxtips-database-1a | 10.0.51.0/24 | us-east-1a |
| linuxtips-database-1b | 10.0.52.0/24 | us-east-1b |
| linuxtips-database-1c | 10.0.53.0/24 | us-east-1c |

**Uso**: RDS, ElastiCache

## 🛡️ Segurança

### Network ACLs
Configuradas especialmente para subnets de banco de dados:
- ✅ Permite portas específicas (3306 MySQL, 6379 Redis)
- ✅ Acesso permitido apenas das subnets privadas
- ❌ Todo outro tráfego é bloqueado

### Componentes de Rede
- 🌐 Internet Gateway para acesso público
- 🔄 NAT Gateways para saída de internet das subnets privadas
- 🛣️ Route Tables específicas para cada tipo de subnet

## 📊 Capacidade

### Nodes (EC2)
- Total de IPs: 12,288 (3 subnets x 4,096 IPs)
- Distribuídos em 3 AZs para alta disponibilidade

### Pods (Kubernetes)
- Total de IPs: 49,152 (3 subnets x 16,384 IPs)
- Otimizado para grande escala de containers

## 🔧 Configuração

### Backend (Terraform State)
```hcl
bucket = "jonoma-it-s3-eks-state-files"
key    = "eks/vpc/prod/state"
region = "us-east-1"
```

### Parameter Store
Armazena automaticamente:
- ID da VPC
- IDs das subnets (públicas, privadas, database)
- Outros parâmetros relevantes

## 📈 Benefícios

1. **Alta Disponibilidade**
   - Distribuição em 3 AZs
   - Redundância de NAT Gateways
   - Design tolerante a falhas

2. **Segurança**
   - Isolamento de recursos
   - Controle de acesso granular
   - Múltiplas camadas de proteção

3. **Escalabilidade**
   - Suporte para milhares de pods
   - CIDRs otimizados
   - Estrutura preparada para crescimento

4. **Manutenibilidade**
   - IaC com Terraform
   - Parâmetros centralizados
   - Estado gerenciado no S3

## 🚀 Uso

1. Configure suas credenciais AWS
2. Inicialize o Terraform:
```bash
terraform init -backend-config=environment/prod/backend.tfvars
```

3. Planeje as alterações:
```bash
terraform plan -var-file=environment/prod/terraform.tfvars
```

4. Aplique a infraestrutura:
```bash
terraform apply -var-file=environment/prod/terraform.tfvars
```

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.