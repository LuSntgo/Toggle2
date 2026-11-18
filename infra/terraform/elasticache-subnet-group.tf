resource "aws_elasticache_subnet_group" "togglemaster" {
  name = "togglemaster-fase4-redis-subnet-group"

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  tags = {
    Name      = "togglemaster-fase4-redis-subnet-group"
    Project   = "ToggleMaster"
    Phase     = "4"
    ManagedBy = "Terraform"
  }
}
