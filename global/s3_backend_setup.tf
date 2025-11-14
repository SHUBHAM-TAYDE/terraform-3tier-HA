terraform {
}


provider "aws" {
region = var.region
}


variable "region" {
type = string
default = "ap-south-1"
}


resource "aws_s3_bucket" "tf_state" {
  bucket = var.bucket_name

  tags = {
    Name = "terraform-state-backend"
  }
}


resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.tf_state.id
  acl    = "private"

  depends_on = [
    aws_s3_bucket_ownership_controls.this
  ]
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}



resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_s3_bucket_public_access_block" "block" {
bucket = aws_s3_bucket.tf_state.id


block_public_acls = true
block_public_policy = true
ignore_public_acls = true
restrict_public_buckets = true
}


# DynamoDB table (optional) for state locking if you prefer classic locking
resource "aws_dynamodb_table" "tf_locks" {
name = "terraform-state-lock"
billing_mode = "PAY_PER_REQUEST"
hash_key = "LockID"


attribute {
name = "LockID"
type = "S"
}
}


variable "bucket_name" {
type = string
}