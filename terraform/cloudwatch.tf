resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${aws_lambda_function.my_lambda.function_name}"
  retention_in_days = 7
}

resource "aws_cloudwatch_metric_alarm" "lambda_error_alarm" {
  alarm_name          = "${var.name}LambdaErrorAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Sum"
  threshold           = "100"
  alarm_description   = "Alarm if Lambda errors exceed 100"
  alarm_actions       = [aws_sns_topic.lambda_error_topic.arn]

  dimensions = {
    FunctionName = aws_lambda_function.my_lambda.function_name
  }
}
