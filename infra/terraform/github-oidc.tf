resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  tags = {
    Name      = "github-actions-oidc"
    Project   = "ToggleMaster"
    Phase     = "4"
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_role" "github_actions_ecr" {
  name = "togglemaster-fase4-github-actions-ecr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
            "token.actions.githubusercontent.com:sub" = "repo:LuSntgo@87209516/Toggle2@1351476768:ref:refs/heads/main"
          }
        }
      }
    ]
  })

  tags = {
    Name      = "togglemaster-fase4-github-actions-ecr-role"
    Project   = "ToggleMaster"
    Phase     = "4"
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_role_policy" "github_actions_ecr" {
  name = "togglemaster-fase4-github-actions-ecr-policy"
  role = aws_iam_role.github_actions_ecr.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "ECRAuthorization"
        Effect = "Allow"

        Action = [
          "ecr:GetAuthorizationToken"
        ]

        Resource = "*"
      },
      {
        Sid    = "ECRPushPull"
        Effect = "Allow"

        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]

        Resource = [
          for repository in aws_ecr_repository.services : repository.arn
        ]
      }
    ]
  })
}

output "github_actions_ecr_role_arn" {
  description = "IAM Role usada pelo GitHub Actions via OIDC para publicar nos ECRs"
  value       = aws_iam_role.github_actions_ecr.arn
}
