resource "aws_api_gateway_rest_api" "my_api" {
  name        = "MyAPIGateway"
  description = "My API Gateway"
}

resource "aws_api_gateway_resource" "my_resource" {
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "hello"
  rest_api_id = aws_api_gateway_rest_api.my_api.id
}

resource "aws_api_gateway_method" "my_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.my_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.my_resource.id
  http_method             = aws_api_gateway_method.my_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.hello_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on  = [aws_api_gateway_integration.lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name  = "prod"
}

output "api_gateway_url" {
  value = aws_api_gateway_deployment.deployment.invoke_url
}
