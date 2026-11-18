resource "aws_dynamodb_table" "analytics" {
  name         = "ToggleMasterAnalytics"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name      = "ToggleMasterAnalytics"
    Project   = "ToggleMaster"
    Phase     = "4"
    ManagedBy = "Terraform"
    Service   = "analytics"
  }
}
