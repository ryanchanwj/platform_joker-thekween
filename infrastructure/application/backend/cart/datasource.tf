data "archive_file" "add_to_cart" {
  type = "zip"

  source_dir  = "${path.module}/functions/add_to_cart"
  output_path = "${path.module}/functions/add_to_cart/add_to_cart.zip"
}

data "archive_file" "update_cart" {
  type = "zip"

  source_dir  = "${path.module}/functions/update_cart"
  output_path = "${path.module}/functions/update_cart/update_cart.zip"
}

data "archive_file" "view_cart" {
  type = "zip"

  source_dir  = "${path.module}/functions/view_cart"
  output_path = "${path.module}/functions/view_cart/view_cart.zip"
}

data "archive_file" "delete_from_cart" {
  type = "zip"

  source_dir  = "${path.module}/functions/delete_from_cart"
  output_path = "${path.module}/functions/delete_from_cart/delete_from_cart.zip"
}

data "aws_s3_bucket" "lambda_functions" {
    bucket = "jokerandthekween-functions"
}