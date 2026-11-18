resource "aws_iam_role_policy" "eks_nodes_app_access" {
  name = "togglemaster-fase4-app-access"
  role = aws_iam_role.eks_nodes.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "SQSAccess"
        Effect = "Allow"

        Action = [
          "sqs:GetQueueUrl",
          "sqs:GetQueueAttributes",
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:ChangeMessageVisibility"
        ]

        Resource = aws_sqs_queue.togglemaster.arn
      },
      {
        Sid    = "DynamoDBAccess"
        Effect = "Allow"

        Action = [
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem"
        ]

        Resource = [
          aws_dynamodb_table.analytics.arn,
          "${aws_dynamodb_table.analytics.arn}/index/*"
        ]
      }
    ]
  })
}
