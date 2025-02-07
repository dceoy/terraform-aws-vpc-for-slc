# trivy:ignore:AVD-AWS-0089
resource "aws_s3_bucket" "storage" {
  for_each      = local.s3_bucket_names
  bucket        = each.value
  force_destroy = var.s3_force_destroy
  tags = {
    Name       = each.value
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}

resource "aws_s3_bucket_logging" "storage" {
  for_each      = { for k, b in aws_s3_bucket.storage : k => b if k != "s3logs" }
  bucket        = each.value.id
  target_bucket = aws_s3_bucket.storage["s3logs"].id
  target_prefix = "${each.value.id}/"
}

resource "aws_s3_bucket_public_access_block" "storage" {
  for_each                = aws_s3_bucket.storage
  bucket                  = each.value.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# trivy:ignore:AVD-AWS-0132
resource "aws_s3_bucket_server_side_encryption_configuration" "storage" {
  for_each = aws_s3_bucket.storage
  bucket   = each.value.id
  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = var.kms_key_arn != null ? "aws:kms" : "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "storage" {
  for_each = aws_s3_bucket.storage
  bucket   = each.value.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "storage" {
  for_each = aws_s3_bucket.storage
  bucket   = each.value.id
  rule {
    status = "Enabled"
    id     = "Move-to-Intelligent-Tiering-after-0day"
    transition {
      days          = 0
      storage_class = "INTELLIGENT_TIERING"
    }
    noncurrent_version_expiration {
      noncurrent_days = var.s3_noncurrent_version_expiration_days
    }
    abort_incomplete_multipart_upload {
      days_after_initiation = var.s3_abort_incomplete_multipart_upload_days
    }
    expiration {
      days                         = var.s3_expiration_days
      expired_object_delete_marker = var.s3_expired_object_delete_marker
    }
  }
}

resource "aws_s3_bucket_policy" "s3logs" {
  count  = contains(keys(aws_s3_bucket.storage), "s3logs") ? 1 : 0
  bucket = aws_s3_bucket.storage["s3logs"].id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "${aws_s3_bucket.storage["s3logs"].id}-policy"
    Statement = [
      {
        Sid    = "S3PutS3ServerAccessLogs"
        Effect = "Allow"
        Principal = {
          Service = "logging.s3.amazonaws.com"
        }
        Action   = ["s3:PutObject"]
        Resource = ["${aws_s3_bucket.storage["s3logs"].arn}/*"]
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = local.account_id
          }
          ArnLike = {
            "aws:SourceArn" = "arn:aws:s3:::${var.system_name}-${var.env_type}-*"
          }
        }
      }
    ]
  })
}

# trivy:ignore:AVD-AWS-0057
resource "aws_iam_policy" "storage" {
  count       = length(aws_s3_bucket.storage) > 0 ? 1 : 0
  name        = "${var.system_name}-${var.env_type}-s3-iam-policy"
  description = "S3 IAM policy"
  path        = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      [
        {
          Sid    = "AllowS3GetAndListActions"
          Effect = "Allow"
          Action = [
            "s3:Describe*",
            "s3:Get*",
            "s3:List*",
            "s3-object-lambda:Get*",
            "s3-object-lambda:List*"
          ]
          Resource = flatten(
            [for a in values(aws_s3_bucket.storage)[*].arn : [a, "${a}/*"]]
          )
        }
      ],
      (
        contains(keys(aws_s3_bucket.storage), "io") ? [
          {
            Sid    = "AllowS3PutObjectActions"
            Effect = "Allow"
            Action = [
              "s3:PutObject*",
              "s3:DeleteObject*"
            ]
            Resource = ["${aws_s3_bucket.storage["io"].arn}/*"]
          }
        ] : []
      ),
      (
        var.kms_key_arn != null ? [
          {
            Sid    = "AllowKMSAccess"
            Effect = "Allow"
            Action = [
              "kms:Decrypt",
              "kms:GenerateDataKey"
            ]
            Resource = [var.kms_key_arn]
          }
        ] : []
      )
    )
  })
  tags = {
    Name       = "${var.system_name}-${var.env_type}-s3-iam-policy"
    SystemName = var.system_name
    EnvType    = var.env_type
  }
}
