# data "archive_file" "create_order" {
#   type = "zip"

#   source_dir  = "${path.module}/functions/create_order"
#   output_path = "${path.module}/functions/create_order/create_order.zip"
# }

# data "archive_file" "view_orders" {
#   type = "zip"

#   source_dir  = "${path.module}/functions/view_orders"
#   output_path = "${path.module}/functions/view_orders/view_orders.zip"
# }

# data "archive_file" "delete_orders" {
#   type = "zip"

#   source_dir  = "${path.module}/functions/delete_orders"
#   output_path = "${path.module}/functions/delete_orders/delete_orders.zip"
# }

data "aws_s3_bucket" "lambda_functions" {
    bucket = "jokerandthekween-functions"
}