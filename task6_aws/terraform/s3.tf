resource "aws_s3_bucket" "my_bucket" {
  bucket = var.task6_s3_bucket
  acl    = "private"
  tags = {
    Name        = "Task6 bucket"
    Environment = terraform.workspace
  }
}
