module "lambda_function" {
  source = "./modules/lambdafunction/"

  function_name = "lambda_function_name"
  handler       = "hello_lambda.lambda_handler"
  runtime       = "python3.6"

  source_path = "../modules/lambdafunction"
}

module "s3-bucket_example_complete" {
  source  = "..modules/s3/aws/"
  version = "1.17.0"
}

module "dynamodb_table" {
  source   = "..modules/dynamodb/"

  name     = "MYDB"
  hash_key = "id"

  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}