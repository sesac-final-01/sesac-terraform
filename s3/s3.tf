resource "aws_s3_bucket" "tfstate_s3" {
  bucket = "terraform-backend-sesacs"
}

resource "aws_s3_bucket_versioning" "tfstate_s3_versioning" {
  bucket = aws_s3_bucket.tfstate_s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

# resource "aws_s3_bucket_policy" "tfstate_bucket_policy" {
#   bucket = aws_s3_bucket.tfstate_s3.id

#   policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": "*",
#       "Action": {
#         "s3:GetObject",
#         "s3:PutObject",
#       }
#       "Resource": "${aws_s3_bucket.tfstate_s3.arn}/*"
#     }
#   ]
# }
# POLICY
# }

### IAM 그룹이 없다면 생성 ###
# resource "aws_iam_group" "iam_group" {
#   name = "iam_groups"
# }

### 기존의 IAM 그룹 "iam_groups" 에 AmazonS3FullAccess 권한 부여
# resource "aws_iam_group_policy_attachment" "iam_group_s3_full_access" {
#   group      = "iam_groups"
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
# }

### iam_user policy S3 full access ###
# resource "aws_iam_user" "user" {
#   name = "sesac-awos"
# }

# resource "aws_iam_user_policy_attachment" "user_s3_access" {
#   user       = aws_iam_user.user.name
#   policy_arn = aws_iam_policy.iam_user_policy.arn
# }

# resource "aws_iam_policy" "iam_user_policy" {
#   name        = "iam-user-policy"
#   description = "Allows access to the example S3 bucket"
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = [
#           "s3:*",
#         ],
#         Resource = [
#           aws_s3_bucket.example_bucket.arn,
#           "${aws_s3_bucket.tfstate_s3.arn}/*",
#         ],
#       },
#     ],
#   })
# }
