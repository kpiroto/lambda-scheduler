// Creating Cloudwatch event rule:

resource "aws_cloudwatch_event_rule" "event_rule" {
    name                      = "${var.cloudwatch_event_rule_name}"
    schedule_expression       = "${var.cloudwatch_schedule_expression}"
}

// Creating Cloudwatch event target:

resource "aws_cloudwatch_event_target" "event_target" {
    target_id                 = "${var.cloudwatch_event_target_id}"
    rule                      = "${aws_cloudwatch_event_rule.event_rule.name}"
    arn                       = "${aws_lambda_function.lambda_function.arn}"
    input                     = "${var.cloudwatch_event_input}"
}

// Creating AWS IAM Role to Lambda

resource "aws_iam_role" "event_target" {
    name                      = "${var.event_target_role_name}"
    assume_role_policy        = "${file("./templates/lambda/${var.event_target_role_name}.json")}"
}

// Creating cloudwatch_event_input policy

resource "aws_iam_policy" "lambda_target_policy" {
  name                        = "${var.lambda_target_policy_name}"
  path                        = "/"
  description                 = "Policy to attach on service that lambda will manage"
  policy                      = "${var.lambda_target_policy}"
}

// Allow Cloudwatch Event Rule to call Lambda function

resource "aws_lambda_permission" "lambda_permission" {
    statement_id              = "AllowExecutionFromCloudWatch"
    action                    = "lambda:InvokeFunction"
    function_name             = "${aws_lambda_function.lambda_function.function_name}"
    principal                 = "events.amazonaws.com"
    source_arn                = "${aws_cloudwatch_event_rule.event_rule.arn}"
}

// Lambda function

resource "aws_lambda_function" "lambda_function" {
    filename                  = "${var.lambda_function_file_name}"
    function_name             = "${var.lambda_function_name}"
    role                      = "${aws_iam_role.event_target.arn}"
    handler                   = "${var.lambda_function_name}.${var.lambda_function_handler}"
    runtime                   = "${var.lambda_function_runtime}"
    timeout                   = "${var.lambda_function_timeout}"
    source_code_hash          = "${base64sha256(file("${var.lambda_function_file_name}"))}"
}
