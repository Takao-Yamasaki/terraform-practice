# セキュリティグループのモジュール化
// セキュリティグループの名前
variable "name" {}
// VPCの名前
variable "vpc_id" {}
// 通信を許可するポート番号
variable "port" {}
// CIDRブロック
variable "cidr_blocks" {
  type = list(string)
}

# セキュリティグループの定義
resource "aws_security_group" "default" {
  name = var.name
  vpc_id = var.vpc_id
}

# セキュリティグループのルール（インバウンド）
# HTTP通信ができるように80番ポートを許可
resource "aws_security_group_rule" "ingress" {
  type = "ingress"
  from_port = var.port
  to_port = var.port
  protocol = "tcp"
  cidr_blocks = var.cidr_blocks
  security_group_id = aws_security_group.default.id
}

# セキュリティグループのルール（アウトバウンド）
resource "aws_security_group_rule" "egress" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.default.id
}

output "security_group_id" {
  value = aws_security_group.default.id
}
