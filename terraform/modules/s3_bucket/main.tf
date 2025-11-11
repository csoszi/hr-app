resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  # ACL removed — bucket is private by default
  # acl = "private"

  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}
