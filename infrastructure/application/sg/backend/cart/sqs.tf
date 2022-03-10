resource "aws_sqs_queue" "queue" {
  name                      = "sg-payment.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
}
