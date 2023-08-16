resource "aws_s3_bucket" "bucket_lambda" {
  bucket = "${var.name}-test-bucket"

  tags = {
    Name = var.name
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket_lambda_oc" {
  bucket = aws_s3_bucket.bucket_lambda.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.bucket_lambda_oc]

  bucket = aws_s3_bucket.bucket_lambda.id
  acl    = "private"
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket_lambda_lifecycle" {
  bucket = aws_s3_bucket.bucket_lambda.id
  rule {
    id     = "lambda_code_cleanup"
    status = "Enabled"

    filter {
      prefix = "/"
    }

    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    expiration {
      days = 60
    }
  }

  rule {
    id     = "lambda_code_cleanup_expired"
    status = "Enabled"

    filter {
      prefix = "/"
    }

    expiration {
      expired_object_delete_marker = true
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_lambda_sse" {
  bucket = aws_s3_bucket.bucket_lambda.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "bucket_lambda_versioning" {
  bucket = aws_s3_bucket.bucket_lambda.id

  versioning_configuration {
    status = "Enabled"
  }
}
