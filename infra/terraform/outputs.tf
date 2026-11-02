# VPC
output "vpc_id" {
  description = "ID da VPC do ToggleMaster"
  value       = aws_vpc.togglemaster.id
}

# EKS
output "eks_cluster_name" {
  description = "Nome do cluster EKS"
  value       = aws_eks_cluster.togglemaster.name
}

output "eks_cluster_endpoint" {
  description = "Endpoint da API do cluster EKS"
  value       = aws_eks_cluster.togglemaster.endpoint
}

# RDS
output "rds_endpoints" {
  description = "Endpoints dos bancos PostgreSQL"
  value = {
    for key, db in aws_db_instance.togglemaster :
    key => db.endpoint
  }
}

output "rds_master_secret_arns" {
  description = "ARNs dos Secrets gerenciados pelo RDS"
  value = {
    for key, db in aws_db_instance.togglemaster :
    key => db.master_user_secret[0].secret_arn
  }
}

# Redis
output "redis_endpoint" {
  description = "Endpoint primario do Redis"
  value       = aws_elasticache_replication_group.togglemaster.primary_endpoint_address
}

output "redis_port" {
  description = "Porta do Redis"
  value       = aws_elasticache_replication_group.togglemaster.port
}

# DynamoDB
output "dynamodb_table_name" {
  description = "Nome da tabela DynamoDB"
  value       = aws_dynamodb_table.analytics.name
}

output "dynamodb_table_arn" {
  description = "ARN da tabela DynamoDB"
  value       = aws_dynamodb_table.analytics.arn
}

# SQS
output "sqs_queue_url" {
  description = "URL da fila SQS"
  value       = aws_sqs_queue.togglemaster.url
}

output "sqs_queue_arn" {
  description = "ARN da fila SQS"
  value       = aws_sqs_queue.togglemaster.arn
}

# ECR
output "ecr_repository_urls" {
  description = "URLs dos repositorios ECR"
  value = {
    for key, repo in aws_ecr_repository.services :
    key => repo.repository_url
  }
}
