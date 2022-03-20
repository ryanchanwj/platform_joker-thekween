resource "aws_s3_bucket" "reports" {
  bucket = "${var.base_domain}-reports"
  lifecycle_rule {
    id = "archive_reports"
    enabled = true
    transition {
      days = 365
      storage_class = "GLACIER"
    }
  }
}
