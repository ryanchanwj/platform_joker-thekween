resource "aws_sqs_queue" "queue" {
  name                      = "hk-payment.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
}
