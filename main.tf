resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname   # must be globally unique
  acl    = "private"                  # access control (optional)
}
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}
resource "aws_s3_object" "index" {
    bucket = aws_s3_bucket.mybucket.id
    key = "index.html"
    source = "index.html"
    acl = "public-read"
    content_type =  "text/html"
  
}

resource "aws_s3_object" "errors" {
    bucket = aws_s3_bucket.mybucket.id
    key = "errors.html"
    source = "errors.html"
    acl = "public-read"
    content_type =  "text/html"
  
}
resource "aws_s3_object" "portfolio" {
    bucket = aws_s3_bucket.mybucket.id
    key = "portfolio_new.png"
    source = "portfolio_new.png"
    acl = "public-read"

}
resource "aws_s3_bucket_website_configuration" "website" {
 bucket = aws_s3_bucket.mybucket.id

   index_document {
     suffix = "index.html"
   }
   error_document {
     key = "errors.html"
   }

   depends_on = [ aws_s3_bucket.mybucket ]
}