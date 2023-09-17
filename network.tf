# VPCの定義
resource "aws_vpc" "example" {
  # CIDRブロックの設定
  cidr_block = "10.0.0.0/16"
  # 名前解決の設定
  enable_dns_support = true
  enable_dns_hostnames = true

  # タグの設定
  tags = {
    Name = "example"
  }
}
