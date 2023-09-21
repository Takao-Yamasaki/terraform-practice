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

# マルチAZ化
# パブリックサブネットの定義(ap-northeast-1a)
resource "aws_subnet" "public_0" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  map_public_ip_on_launch = true
}

# パブリックサブネットの定義(ap-northeast-1c)
resource "aws_subnet" "public_1" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-1c"
  map_public_ip_on_launch = true
}

# インターネットゲートウェイの定義
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

# ルートテーブルの定義（パブリックサブネット用）
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example.id
}

# ルートの定義
resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  gateway_id = aws_internet_gateway.example.id
  destination_cidr_block = "0.0.0.0/0"
}

# マルチAZ化
# ルートテーブルの関連付け
# パブリックサブネット:public_0とルートテーブル（パブリックサブネット用）の関連付け
resource "aws_route_table_association" "public_0" {
  subnet_id = aws_subnet.public_0.id
  route_table_id = aws_route_table.public.id
}

# パブリックサブネット:public_1とルートテーブル（パブリックサブネット用）の関連付け
resource "aws_route_table_association" "public_1" {
  subnet_id = aws_subnet.public_1
  route_table_id = aws_route_table.public.id
}

# プライベートサブネットの定義
resource "aws_subnet" "private" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.64.0/24"
  availability_zone = "ap-northeast-1a"
  # パブリックIPアドレスは不要
  map_public_ip_on_launch = false
}

# プライベートルートテーブルの定義
# NOTE: プライベートなので、インターネットゲートウェイに対するルーティングは不要
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.example.id
}

# プライベートルートテーブルの関連付け
resource "aws_route_table_association" "private" {
  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# EIPの定義
resource "aws_eip" "nat_gateway" {
  vpc = true
  depends_on = [ aws_internet_gateway.example ]
}

# NATゲートウェイの定義
# TODO: NATゲートウェイの冗長化
resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id = aws_subnet.public.id
  depends_on = [ aws_internet_gateway.example ]
}

# プライベートのルートの定義
resource "aws_route" "private" {
  route_table_id = aws_route_table.public.id
  nat_gateway_id = aws_nat_gateway.example.id
  destination_cidr_block = "0.0.0.0/0"
}
