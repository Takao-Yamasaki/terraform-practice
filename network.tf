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

# パブリックサブネットの定義
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-1a"
}

# インターネットゲートウェイの定義
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

# ルートテーブルの定義
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id
}
