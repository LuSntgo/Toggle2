resource "aws_security_group" "redis" {
  name        = "togglemaster-fase4-redis-sg"
  description = "Security Group for ToggleMaster Redis"
  vpc_id      = aws_vpc.togglemaster.id

  ingress {
    description = "Redis from EKS cluster"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"

    security_groups = [
      aws_eks_cluster.togglemaster.vpc_config[0].cluster_security_group_id
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "togglemaster-fase4-redis-sg"
    Project   = "ToggleMaster"
    Phase     = "4"
    ManagedBy = "Terraform"
  }
}
