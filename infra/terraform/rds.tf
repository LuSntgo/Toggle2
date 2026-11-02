locals {
  rds_databases = {
    auth = {
      identifier = "togglemaster-fase4-auth-db"
      db_name    = "auth_db"
    }

    flag = {
      identifier = "togglemaster-fase4-flag-db"
      db_name    = "flags_db"
    }

    targeting = {
      identifier = "togglemaster-fase4-targeting-db"
      db_name    = "targeting_db"
    }
  }
}

resource "aws_db_instance" "togglemaster" {
  for_each = local.rds_databases

  identifier = each.value.identifier

  engine         = "postgres"
  instance_class = "db.t4g.micro"

  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = each.value.db_name
  username = "postgres"

  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.togglemaster.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  publicly_accessible = false
  multi_az            = false

  backup_retention_period = 1

  deletion_protection = false
  skip_final_snapshot = true

  performance_insights_enabled = false

  tags = {
    Name      = each.value.identifier
    Project   = "ToggleMaster"
    Phase     = "4"
    ManagedBy = "Terraform"
    Service   = each.key
  }
}
