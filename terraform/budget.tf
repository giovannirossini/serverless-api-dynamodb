resource "aws_budgets_budget" "serverless_budget" {
  name              = "serverless-budget"
  budget_type       = "COST"
  limit_amount      = 1
  limit_unit        = "USD"
  time_period_start = "2023-01-01_00:00"
  time_period_end   = "2025-12-31_23:59"

  time_unit = "MONTHLY"

  cost_types {
    include_credit             = false
    include_discount           = true
    include_other_subscription = true
    include_recurring          = true
    include_refund             = true
    include_subscription       = true
    include_support            = true
    include_tax                = true
    include_upfront            = true
    use_amortized              = false
    use_blended                = true
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 90
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [var.email_notification]
  }

  cost_filter {
    name   = "Service"
    values = ["All"]
  }

  cost_filter {
    name   = "TagTagKeyValue"
    values = ["Environment$serverless-api-dynamodb"]
  }
}
