resource "random_string" "random_name" {
    length = 8
    upper = false
    special = false
}

resource "aws_iam_user" "admin_user" {
    name = "admin_${random_string.random_name.id}"
}

resource "aws_iam_access_key" "admin_user_access_key" {
  user = aws_iam_user.admin_user
}

resource "aws_iam_user_policy" "admin_user_policy" {
  
}