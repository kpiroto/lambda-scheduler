# Module: Terraform lambda scheduler

Terraform module to schedule lambda scripts

## Terraform Components:

 - aws_cloudwatch_event_rule
 - aws_cloudwatch_event_target
 - aws_iam_role
 - aws_iam_policy
 - aws_iam_role_policy_attachment
 - aws_lambda_permission
 - aws_lambda_function

```
lambda-scheduler/
├── input.tf
├── lambda_scheduler.tf
├── output.tf
├── policies_attachments.tf
├── README.md
├── temp
└── templates
    └── lambda
            └── event_target_role_name.json
```

### Variables:

`cloudwatch_schedule_expression`:

  - Format: string

  - Example: "cron(0 1 ? * * *)" or rate(5 minutes). This cron uses AWS format:

  cron(Minutes Hours Day-of-month Month Day-of-week Year)

  Attention:

  - AWS crontab uses values 1-7 for Days-of-week.
  - AWS uses UTC.

  - Reference: http://docs.aws.amazon.com/lambda/latest/dg/tutorial-scheduled-events-schedule-expressions.html

`cloudwatch_event_target_id`:

  - Format: string

  - Example: "check-lambda-scheduler-RDS"

`cloudwatch_event_input`:

  - Format: string

  - Description: Valid JSON input policy. In this input field we can add
    parameters that will be passed to the script called by lambda function.

  - Example:

```
  {
    "bucket": "my_bucket",
    "file_path": "path/to/file"
  }
```

`lambda_file_name`:

  - Format: string

  - Description: File name with lambda functions. This file should be in zip format.

`lambda_target_policy_name`:

  - Format: string

  - Description: Lambda target policy name

`lambda_function_name`:

  - Format: string

  - Description: Lambda Function name

`lambda_function_timeout`:

  - Format: string

  - Description: The amount of time Lambda Function has to run in seconds

`event_target_role_name`:

  - Format: string

  - Description: (Required) Role file name that will be created to Lambda.

    A file with this name and with a .json suffix have to be created

    under templates/lambda directory.

### Usage:

This example will create an stop and start schedule to an RDS instance:

```
// Schedule Stop

module "rds_scheduler_stop"  {
 source                                = "git:://https://github.com/kpiroto/lambda-scheduler/releases/tag/v0.0.1"
 cloudwatch_event_rule_name            = "stop_test_RDS"
 cloudwatch_schedule_expression        = "cron(0 3 ? * SAT *)"
 cloudwatch_event_target_id            = "stop_rds_target"
 cloudwatch_event_input                = <<EOF
{
  "rds_ids": "${lookup(module.rds_mysql_test.db_instance, "id")}",
  "region": "us-east-1"
}
EOF

 lambda_target_policy                  = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "rds:StopDBInstance"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
 lambda_function_file_name             = "./templates/lambda/lambda_stop_rds.zip"
 lambda_target_policy_name             = "stop_rds"
 lambda_function_name                  = "stop_rds"
 event_target_role_name                = "rds_scheduler_stop"
}

// Schedule Start

module "rds_scheduler_start"  {
 source                                = "git::ssh://git@git.appi.corp.local/devops/terraform-module-lambda-scheduler.git?ref=v0.0.1"
 cloudwatch_event_rule_name            = "start_test_RDS"
 cloudwatch_schedule_expression        = "cron(0 11 ? * MON *)"
 cloudwatch_event_target_id            = "start_rds_target"
 cloudwatch_event_input                = <<EOF
{
  "rds_ids": "${lookup(module.rds_mysql_test.db_instance, "id")}",
  "region": "us-east-1"
}
EOF

 lambda_target_policy                  = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "rds:StartDBInstance"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF

 lambda_function_file_name             = "./templates/lambda/lambda_start_rds.zip"
 lambda_target_policy_name             = "start_rds"
 lambda_function_name                  = "start_rds"
 event_target_role_name                = "rds_scheduler_start"
}
```
