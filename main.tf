terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws",
            version = "~> 4.0.0"
        }
    }
    required_version = "~> 1.2.3"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "slsapp1-lambda-bucket"
  # acl = "private"
  force_destroy = true
}

data "archive_file" "lambda_hello_world" {
  source_dir = "${path.module}/lambda/hello-world"
  output_path = "${path.module}/lambda/hello-world.zip"
  type = "zip"
}

resource "aws_s3_object" "lambda_hello_world" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key = "hello-world.zip"
  source = data.archive_file.lambda_hello_world.output_path
  etag = filemd5(data.archive_file.lambda_hello_world.output_path)
}

resource "aws_iam_role" "lambda_exec" {
  name = "slsapp1-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "hello_world" {
  function_name = "slsapp1-HelloWorld"
  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key = aws_s3_object.lambda_hello_world.key
  runtime = "nodejs14.x"
  handler = "hello.handler"
  source_code_hash = data.archive_file.lambda_hello_world.output_base64sha256
  role = aws_iam_role.lambda_exec.arn
}