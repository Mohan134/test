resource "aws_iam_role" "iam_for_lambda" { # creating the I am role lambda function can acces the dynamo db table 
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
{  
  "Version": "2012-10-17",
  "Statement":[{
    "Effect": "Allow",
    "Action": [
     "dynamodb:BatchGetItem",
     "dynamodb:GetItem",
     "dynamodb:Query",
     "dynamodb:Scan",
     "dynamodb:BatchWriteItem",
     "dynamodb:PutItem",
     "dynamodb:UpdateItem"
    ],
    "Resource": "arn:aws:dynamodb:us-east-1:987456321456:table/myDB"
   }
  ]
}
EOF
}
resource "archive_file_zip" {
    type = "zip"
    source_file = "hello_lamba.py"
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "archive_file_zip.hello_lamba.py"
  function_name = "lambda_function_name"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "hello_lambda.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "python3.6"
  memory_size        = "128"
  concurrency        = "5"
  lambda_timeout     = "20"
  log_retention      = "1"

  environment {
    variables = {
      greeting = "hello"
    }
  }
}

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

  etag = filemd5("Downloads/book1.xlsv")

}
# adding s3 bucket as triggerd to my lambda function 

resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
bucket = "${my-test-bucket-eu-west-1}"
lambda_function {
lambda_function_arn = "${aws_lambda_function.lambda_function_name.arn}"
events              = ["s3:ObjectCreated:*"]
filter_prefix       = "file-prefix"
filter_suffix       = "file-extension"
}
}
