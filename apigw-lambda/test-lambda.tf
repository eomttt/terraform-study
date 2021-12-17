# variable "test_lambda_function_name" {
#   default = "test-lambda-function-name"
# }

# resource "aws_lambda_function" "test_lambda" {
#   function_name = var.test_lambda_function_name
#   runtime = "python3.8"
#   handler       = "index.handler"
#   filename      = "functions.zip"
#   role = aws_iam_role.iam_for_test_lambda.arn
# }

# resource "aws_iam_role" "iam_for_test_lambda" {
#   name = "iam_for_test_lambda"

#   assume_role_policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Action": "sts:AssumeRole",
#         "Principal": {
#             "Service": "lambda.amazonaws.com"
#         },
#         "Effect": "Allow",
#         "Sid": ""
#       }
#     ]
#   })
# }
