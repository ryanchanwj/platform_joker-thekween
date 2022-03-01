module "this" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = ">=1.1.0"

  create_table = var.create_table

  name           = var.name_suffix
  billing_mode   = var.billing_mode
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = var.hash_key
  attributes     = var.attributes
  range_key      = var.range_key

  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_view_type

  server_side_encryption_enabled     = var.server_side_encryption_enabled
  server_side_encryption_kms_key_arn = var.server_side_encryption_kms_key_arn

  replica_regions                = var.replica_regions
  point_in_time_recovery_enabled = var.point_in_time_recovery_enabled

  global_secondary_indexes = var.global_secondary_indexes
  local_secondary_indexes  = var.local_secondary_indexes

  autoscaling_defaults = var.autoscaling_defaults
  autoscaling_indexes  = var.autoscaling_indexes
  autoscaling_read     = var.autoscaling_read
  autoscaling_write    = var.autoscaling_write

  timeouts           = var.timeouts
  ttl_attribute_name = var.ttl_attribute_name
  ttl_enabled        = var.ttl_enabled
}
