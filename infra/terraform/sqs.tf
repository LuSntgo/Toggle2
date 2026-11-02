resource "aws_sqs_queue" "togglemaster" {
  name = "togglemaster-fase4-queue"

  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600

  sqs_managed_sse_enabled = true

  tags = {
    Name      = "togglemaster-fase4-queue"
    Project   = "ToggleMaster"
    Phase     = "4"
    ManagedBy = "Terraform"
  }
}
