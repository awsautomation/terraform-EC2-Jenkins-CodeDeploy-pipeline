output "release_s3_bucket_name" {
  description = "The name of the release S3 bucket"
  value = aws_s3_bucket.release_bucket.id
}