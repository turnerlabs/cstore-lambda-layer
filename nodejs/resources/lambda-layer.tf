data "archive_file" "cstore" {
    type        = "zip"
    source_dir  = "cstore"
    output_path = "cstore.zip"
}

resource "aws_lambda_layer_version" "cstore" {
  filename   = "cstore.zip"
  layer_name = "cstore-nodejs"
  description = "v3.6.0-alpha"

  source_code_hash = data.archive_file.cstore.output_base64sha256

  compatible_runtimes = ["nodejs10.x"]
}

data "aws_caller_identity" "current" {}

output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

output "cstore_lambda_layer_arn" {
  value = aws_lambda_layer_version.cstore.arn
}