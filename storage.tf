# プライベートバケットの定義
resource "aws_s3_bucket" "private" {
  # バケット名
  # TODO: apply時は、別のバケット名にすること
  bucket = "private-pragmatic-terraform-zakzak"

  # バージョニングの設定
  versioning {
    enabled = true
  }
  
  # サーバーサイド暗号化の設定
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# ブロックパブリックアクセスの定義
resource "aws_s3_bucket_public_access_block" "private" {
  bucket = aws_s3_bucket.private.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

# パブリックバケット
resource "aws_s3_bucket" "public" {
  # TODO: apply時は、別のバケット名にすること
  bucket = "public-progmatic-terraform-zakzak"
  # ACLの設定で、インターネットからの読み込みを許可
  # 明示的にプライベートで宣言
  # acl = "private"

# CORSの設定
  cors_rule {
    allowed_origins = ["https://example.com"]
    allowed_methods = ["GET"]
    allowed_headers = ["*"]
    max_age_seconds = 3000
  }
}

# ログローテーションバケット
resource "aws_s3_bucket" "alb_log" {
  # TODO: apply時は、別のバケット名にすること
  bucket = "alb-log-progmatic-terraform-zakzak"

  # ライフサイクルの設定
  lifecycle_rule {
    enabled = true

    expiration {
      days = "180"
    }
  }
}

# バケットポリシーの設定
resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log.id
  policy = data.aws_iam_policy_document.alb_log.json
}

data "aws_iam_policy_document" "alb_log" {
  statement {
    effect = "Allow"
    actions = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log.id}/*"]

    principals{
      type = "AWS"
      identifiers = ["786832920677"]
    }
  }
}
