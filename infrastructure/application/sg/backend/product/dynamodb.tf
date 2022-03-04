module "orders_db" {
  source      = "../../../../../modules/dynamodb"

  name_suffix = "orders_db"

  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = 0
  write_capacity = 0
  autoscaling_read = {
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
    target_value       = 10
    max_capacity       = 8
  }

  autoscaling_write = {
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
    target_value       = 10
    max_capacity       = 8
  }

  autoscaling_indexes = {
    TitleIndex = {
      read_max_capacity  = 10
      read_min_capacity  = 0
      write_max_capacity = 10
      write_min_capacity = 0
    }
  }

#   point_in_time_recovery_enabled = true
  
  hash_key  = "UserId"
  range_key = "Id"

  attributes = [
    {
      name = "UserId"
      type = "N"
    },
    {
      name = "Id"
      type = "N"
    },
    # {
    #   name = "Price"
    #   type = "N"
    # },
    # {
    #   name = "Quantity"
    #   type = "N"
    # }
  ]

#   global_secondary_indexes = [
#     {
#       name               = "UserIndex"
#       hash_key           = "UserId"
#       range_key          = "UserId"
#       projection_type    = "INCLUDE"
#       non_key_attributes = ["Price", "Quantity"]
#     }
#   ]
}