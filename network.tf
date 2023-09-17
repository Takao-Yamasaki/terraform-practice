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
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example.id
}

# ルートの定義
resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  gateway_id = aws_internet_gateway.example.id
  destination_cidr_block = "0.0.0.0/0"
}

# ルートテーブルの関連付け
resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public.id
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

# ルートテーブルの定義
# NOTE: プライベートなので、インターネットゲートウェイに対するルーティングは不要
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.example.id
# NOTE: NATゲートウェイに対するルーティングを追加
  nat_gateway_id = aws_nat_gateway.example.id
  destination_cidr_block = "0.0.0.0/0"
}

# ルートテーブルの関連付け
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
resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id = aws_subnet.public.id
  depends_on = [ aws_internet_gateway.example ]
}
