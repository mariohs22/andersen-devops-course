resource "aws_s3_bucket" "s3-bucket" {
  bucket = var.task6_s3_bucket
  #  acl    = "private"
  acl = "public-read"
  tags = {
    Name        = "Task6 bucket"
    Environment = terraform.workspace
  }
}


# resource "aws_s3_bucket" "s3-bucket" {
#   bucket = var.aws-s3bucket-name
#   acl    = "public-read"
#   tags = {
#     Name    = "devops.l2-prod"
#     Project = var.resource-project
#     Owner   = var.resource-owner
#     Env     = var.resource-env
#   }
# }

resource "aws_s3_bucket_object" "file_upload" {
  bucket = var.task6_s3_bucket
  acl    = "public-read"
  key    = "index.html"
  source = "./index.html"
  depends_on = [
    aws_s3_bucket.s3-bucket
  ]
}
