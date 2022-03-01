output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = module.this.dynamodb_table_arn
}
output "dynamodb_table_id" {
  description = "ID of the DynamoDB table"
  value       = module.this.dynamodb_table_id
}
output "dynamodb_table_stream_arn" {
  description = "The ARN of the Table Stream. Only available when var.stream_enabled is true"
  value       = var.stream_enabled ? module.this.dynamodb_table_stream_arn : null
}

output "dynamodb_table_stream_label" {
  description = "A timestamp, in ISO 8601 format of the Table Stream. Only available when var.stream_enabled is true"
  value       = var.stream_enabled ? module.this.dynamodb_table_stream_label : null
}
