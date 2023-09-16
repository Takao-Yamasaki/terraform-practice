# ポリシードキュメントの定義
data "aws_policy_document" "allow_describe_regions" {
  statement {
    effect = "Allow"
    # リージョン一覧を取得する
    actions = ["ec2:DescribeRegions"]
    resource = ["*"]
  }
}

# IAM ポリシー
resource "aws_iam_policy" "example" {
  name = "example"
  policy = data.aws_iam_policy_document.allow_describe_regions.json
}
