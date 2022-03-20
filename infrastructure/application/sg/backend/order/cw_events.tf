resource "aws_cloudwatch_event_rule" "report" {
  name                = "weekly-sales-report-generation"
  description         = "Generates sales report at 00:00 on every Saturday"
  schedule_expression = "cron(0 16 ? * 6 *)"
}

resource "aws_cloudwatch_event_target" "report" {
  rule      = "${aws_cloudwatch_event_rule.report.name}"
  target_id = "lambda"
  arn       = "${module.lambda_generate_report.invoke_arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_check_foo" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${module.lambda_generate_report.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.report.arn}"
}