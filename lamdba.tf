provider "aws" {
  region = "us-east-1"  # Change to your desired region
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_lambda_function" "hello_lambda" {
  filename      = "hello_lambda.py"
  function_name = "helloLambdaFunction"
  role          = aws_iam_role.lambda_role.arn
  handler       = "hello_lambda.lambda_handler"
  runtime       = "python3.8"
}

output "lambda_function_arn" {
  value = aws_lambda_function.hello_lambda.arn
}
