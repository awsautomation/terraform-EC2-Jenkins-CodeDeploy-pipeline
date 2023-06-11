variable "release_s3_bucket_name" {
  description = "The name of the release S3 bucket"
}

# Creating an S3 bucket that will hold our releases
resource "aws_s3_bucket" "release_bucket" {
  # Naming the bucket the release_s3_bucket_name variable
  bucket = var.release_s3_bucket_name
  # Set force destroy to true. This will allow terraform to destroy
  # the S3 bucket when we tear down.
  force_destroy = true
}

# Set the ACL of the S3 bucket to private
resource "aws_s3_bucket_acl" "release_bucket_acl" {
  bucket = aws_s3_bucket.release_bucket.id
  acl = "private"
}

# Enabled versioning on the S3 bucket
resource "aws_s3_bucket_versioning" "release_bucket_versioning" {
  bucket = aws_s3_bucket.release_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}