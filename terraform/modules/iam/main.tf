resource "aws_iam_user" "users" {
  for_each = var.users
  name     = each.key
}

resource "aws_iam_user_policy" "users_policies" {
  for_each = var.users

  user = aws_iam_user.users[each.key].name

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = each.value
  })
}

resource "aws_iam_access_key" "users_keys" {
  for_each = var.users
  user     = aws_iam_user.users[each.key].name
}