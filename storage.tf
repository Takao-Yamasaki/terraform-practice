# プライベートバケットの定義
resource "aws_s3_bucket" "private" {
  # バケット名
  # TODO: apply時は、別のバケット名にすること
  bucket = "private-pragmatic-terraform"

  # バージョニング
  versioning {
    enabled = true
  }

  # 暗号化
  server_side_encryption_configuration {
    role {
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
