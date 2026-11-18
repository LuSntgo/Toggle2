locals {
  ecr_repositories = toset([
    "auth-service",
    "flag-service",
    "targeting-service",
    "evaluation-service",
    "analytics-service"
  ])
}

resource "aws_ecr_repository" "services" {
  for_each = local.ecr_repositories

  name                 = each.value
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name      = each.value
    Project   = "ToggleMaster"
    Phase     = "4"
    ManagedBy = "Terraform"
  }
}
