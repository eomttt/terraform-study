variable "hello_world_function_name" {
  default = "hello-world"
}

# configures the Lambda function
resource "aws_lambda_function" "hello_world" {
  function_name = var.hello_world_function_name
  runtime = "python3.8"
  handler       = "index.handler"
  filename      = "functions.zip"
  role = aws_iam_role.iam_for_hello_world.arn
}

# Defines a log group to store log messages from Lambda function
# Lambda stores logs in a group with the name /aws/lambda/<function_name>
resource "aws_cloudwatch_log_group" "hello_world" {
  name = "/aws/lambda/${aws_lambda_function.hello_world.function_name}"
  retention_in_days = 30
}

# Defines ans IAM role that allows Lambda to access resources
resource "aws_iam_role" "iam_for_hello_world" {
  name = "iam_for_hello_world"

  assume_role_policy = jsonencode({
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
  })
}

# Attaches policy the IAM role
# AWSLambdaBasicExecutionRole is ans AWS managed policy that allows Lambda function to write to CloudWath logs
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.iam_for_hello_world.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


# Configure Api Gateway to use your Lambda function
resource "aws_apigatewayv2_integration" "hello_world" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.hello_world.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

# Maps an HTTP reqeust to a target, in this case Lmabda function.
# Target matching integrations/<ID> maps to lambda integration with the given ID
resource "aws_apigatewayv2_route" "hello_world" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.hello_world.id}"
}


# Gives API Gateway permissin to invocke Lambda function
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_world.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}