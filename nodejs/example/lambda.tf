variable "cstore_lambda_layer_arn" {
}

data "aws_caller_identity" "current" {}

data "archive_file" "example" {
    type        = "zip"
    source_dir  = "lambda"
    output_path = "lambda.zip"
}

resource "aws_lambda_function" "example" {
  filename      = "lambda.zip"
  function_name = "cstore_lambda_example"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "handler.test"
  timeout = 10
  runtime = "nodejs10.x"

  source_code_hash = "${data.archive_file.example.output_base64sha256}"

  layers = ["${var.cstore_lambda_layer_arn}"]

  environment {
    variables = {
      ENV = "dev"
    }
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
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
}
EOF
}

resource "aws_iam_role_policy" "cstore_example_policy" {
  name = "cstore_example_policy"
  role = aws_iam_role.iam_for_lambda.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParametersByPath"
      ],
      "Resource": "arn:aws:ssm:us-east-1:${data.aws_caller_identity.current.account_id}:parameter/${aws_lambda_function.example.function_name}/*"
    }
  ]
}
EOF

}