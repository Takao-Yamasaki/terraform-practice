# IAMロールモジュールの定義
# 入力値の定義
variable "name" {}
variable "policy" {}
variable "identifiers" {}

# IAMロールの定義
resource "aws_iam_role" "default" {
  name = var.name
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

# 信頼ポリシー
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [var.identifiers]
    }
  }
}

# IAM ポリシー
resource "aws_iam_policy" "default" {
  name = var.name
  policy = var.policy
}

# IAMポリシーのアタッチ
resource "aws_iam_role_policy_attachment" "default" {
  role = aws_iam_role.default.name
  policy_arn = aws_iam_policy.default.arn
}

output "iam_role_arn" {
  value = aws_iam_role.default.arn
}

output "iam_role_name" {
  value = aws_iam_policy.default.name
}

