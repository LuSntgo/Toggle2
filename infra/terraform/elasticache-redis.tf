resource "aws_elasticache_replication_group" "togglemaster" {
  replication_group_id = "togglemaster-fase4-redis"
  description          = "Redis for ToggleMaster Phase 4"

  engine             = "redis"
  node_type          = "cache.t4g.micro"
  port               = 6379
  num_cache_clusters = 1

  subnet_group_name  = aws_elasticache_subnet_group.togglemaster.name
  security_group_ids = [aws_security_group.redis.id]

  automatic_failover_enabled = false
  multi_az_enabled           = false

  at_rest_encryption_enabled = true
  transit_encryption_enabled = true

  snapshot_retention_limit = 0

  tags = {
    Name      = "togglemaster-fase4-redis"
    Project   = "ToggleMaster"
    Phase     = "4"
    ManagedBy = "Terraform"
  }
}
