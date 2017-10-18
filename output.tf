output "role" {
  value = "${aws_iam_role.event_target.name}"
}

output "role_arn" {
  value = "${aws_iam_role.event_target.arn}"
}

output "policy" {
  value = "${aws_iam_policy.lambda_target_policy.name}"
}

output "policy_arn" {
  value = "${aws_iam_policy.lambda_target_policy.arn}"
}

output "event_rule" {
  value = "${aws_cloudwatch_event_rule.event_rule.name}"
}

output "event_target_arn" {
  value = "${aws_cloudwatch_event_target.event_target.arn}"
}

output "aws_lambda_function" {
  value = "${aws_lambda_function.lambda_function.function_name}"
}
