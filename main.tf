resource "aws_s3_bucket" "bucket" { # creating S3 bucket  
bucket = "my-test-bucket-eu-west-1"
acl    = "private"
tags = {
Name        = "My bucket"
Environment = "Dev"
}
}

# upload the file in s3 bucket 
Upload an object
resource "aws_s3_bucket_object" "object" {

  bucket = "my-test-bucket-eu-west-1"

  key    = "profile"

  acl    = "private"  # or can be "public-read"

  source = "Downloads/book1.xlsv"

  etag = filemd5("Downloads/testfile.xlsv")

}