resource "aws_iam_group" "frontend_group" {
  name = var.group_name
}

resource "aws_iam_user" "frontend_user" {
  name = var.user_name
}

resource "aws_iam_group_membership" "frontend_group_membership" {
  name  = "frontend_group_membership"
  users = [aws_iam_user.frontend_user.name]
  group = aws_iam_group.frontend_group.name
}