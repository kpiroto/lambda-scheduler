// Attaching Policy to resource

resource "aws_iam_role_policy_attachment" "lambda_assumed_role_policy_attachment" {
    role                      = "${aws_iam_role.event_target.name}"
    policy_arn                = "${aws_iam_policy.lambda_target_policy.arn}"
}

// Attach AWS Default policy to allow lambda execute our functions

resource "aws_iam_role_policy_attachment" "basic-exec-role" {
    role                      = "${aws_iam_role.event_target.name}"
    policy_arn                = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
