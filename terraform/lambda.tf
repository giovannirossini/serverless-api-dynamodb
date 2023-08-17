resource "aws_lambda_function" "my_lambda" {
  function_name = "${var.name}-lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda.handler"
  runtime       = "python3.8"
  s3_bucket     = aws_s3_bucket.bucket_lambda.id
  s3_key        = "lambda.zip"
  memory_size   = 128

  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.my_dynamodb_table.name
    }
  }
}

resource "aws_iam_policy" "dynamodb_policy" {
  name        = "dynamodb-policy"
  description = "Permissions for DynamoDB"

  policy = templatefile("${path.module}/templates/dynamodb-policy.json", {
    dynamodb_arn = aws_dynamodb_table.my_dynamodb_table.arn
  })
}

resource "aws_iam_role_policy_attachment" "dynamodb_attachment" {
  policy_arn = aws_iam_policy.dynamodb_policy.arn
  role       = aws_iam_role.lambda_role.name
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-role"

  assume_role_policy = file("${path.module}/templates/lambda-role.json")
}

resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = file("${path.module}/templates/lambda-logging-policy.json")
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
