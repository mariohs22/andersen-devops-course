resource "aws_s3_bucket" "task6_http" {
  bucket        = var.s3_bucket_http_name
  acl           = "private"
  force_destroy = true
  tags = {
    Name = "My task6 bucket web"
  }
}

# Upload an object
resource "aws_s3_bucket_object" "file_upload" {
  bucket       = aws_s3_bucket.task6_http.id
  acl          = "private"
  key          = "index.html"
  source       = "scripts/index.html"
  etag         = filemd5("scripts/index.html")
  content_type = "text/html"
  depends_on = [
    aws_s3_bucket.task6_http
  ]
}
