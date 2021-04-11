# S3 버킷 생성
resource "aws_s3_bucket" "terraform-bucket-potato" {
  bucket = "terraform-bucket-potato"
  acl    = "private"

  tags = {
    Name        = "terraform-bucket-potato"
  }
}

# 퍼블릭 액세스 허용
resource "aws_s3_bucket_public_access_block" "example-potato" {
  bucket = aws_s3_bucket.terraform-bucket-potato.id

  block_public_acls   = false
  block_public_policy = false
  
}