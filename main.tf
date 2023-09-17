# ポリシードキュメントの定義
data "aws_iam_policy_document" "allow_describe_regions" {
  statement {
    effect = "Allow"
    # リージョン一覧を取得する
    actions = ["ec2:DescribeRegions"]
    resources = ["*"]
  }
}

module "describe_regions_for_ec2" {
  source = "./iam_role"
  name = "describe-regions-for-ec2"
  identifiers = "ec2.amazonaws.com"
  policy = data.aws_iam_policy_document.allow_describe_regions.json
}
