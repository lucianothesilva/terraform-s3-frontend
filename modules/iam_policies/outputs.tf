output "cloudfront_policy_arn" {
  value = aws_iam_policy.cloudfront_policy.arn
}

output "s3_policy_arn" {
  value = aws_iam_policy.s3_policy.arn
}

output "frontend_group_name" {
  value = aws_iam_group.frontend_group.name
}

output "frontend_user_name" {
  value = aws_iam_user.frontend_user.name
}
