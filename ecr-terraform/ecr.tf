resource "aws_ecr_repository" "ecr_simpleecommerce" {
  name                 = var.registry_name_productsapi
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# data "aws_iam_policy_document" "ecommerce_policy" {
#   statement {
#     sid    = "ecommerce_policy"
#     effect = "Allow"

#     principals {
#       type        = "AWS"
#       identifiers = ["123456789012"]
#     }

#     actions = [
#       "ecr:GetDownloadUrlForLayer",
#       "ecr:GetAuthorizationToken",
#       "ecr:BatchGetImage",
#       "ecr:BatchCheckLayerAvailability",
#       "ecr:PutImage",
#       "ecr:InitiateLayerUpload",
#       "ecr:UploadLayerPart",
#       "ecr:CompleteLayerUpload",
#       "ecr:DescribeRepositories",
#       "ecr:GetRepositoryPolicy",
#       "ecr:ListImages",
#       "ecr:DeleteRepository",
#       "ecr:BatchDeleteImage",
#       "ecr:SetRepositoryPolicy",
#       "ecr:DeleteRepositoryPolicy",
#     ]
#   }
# }

resource "aws_ecr_repository_policy" "ecommerce_policy" {
  repository = aws_ecr_repository.ecr_simpleecommerce.name
  policy     = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "adds full ecr access to anyone",
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetAuthorizationToken",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability",
            "ecr:PutImage",
            "ecr:InitiateLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:CompleteLayerUpload",
            "ecr:DescribeRepositories",
            "ecr:GetRepositoryPolicy",
            "ecr:ListImages",
            "ecr:DeleteRepository",
            "ecr:BatchDeleteImage",
            "ecr:SetRepositoryPolicy",
            "ecr:DeleteRepositoryPolicy"
        ]
      }
    ]
  }
  EOF
}

resource "aws_ecr_lifecycle_policy" "ecr_lifecycle_policy_untagged_eastus1_simple_ecommerce" {
  repository = aws_ecr_repository.ecr_simpleecommerce.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 14 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 14
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

resource "aws_ecr_lifecycle_policy" "ecr_lifecycle_policy_tagged_eastus1_simple_ecommerce" {
  repository = aws_ecr_repository.ecr_simpleecommerce.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 30 images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["v"],
                "countType": "imageCountMoreThan",
                "countNumber": 30
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}