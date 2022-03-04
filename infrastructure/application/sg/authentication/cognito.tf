// Resources
resource "aws_cognito_user_pool" "user_pool" {
  name = "customers"

#   account_recovery_setting {
#     name = "verified_email"
#     priority = 1
#   }

#   username_attributes = ["email"]
#   auto_verified_attributes = ["email"]

  password_policy {
    minimum_length = 6
  }

#   verification_message_template {
#     default_email_option = "CONFIRM_WITH_CODE"
#     email_subject = "Account Confirmation"
#     email_message = "Your confirmation code is {####}"
#   }

#   schema {
#     attribute_data_type      = "String"
#     developer_only_attribute = false
#     mutable                  = true
#     name                     = "email"
#     required                 = true

#     string_attribute_constraints {
#       min_length = 1
#       max_length = 256
#     }
#   }
}

resource "aws_cognito_user_pool_client" "client" {
  name = "cognito-client"

  user_pool_id = aws_cognito_user_pool.user_pool.id
  generate_secret = false
  refresh_token_validity = 90
  prevent_user_existence_errors = "ENABLED" //error message to not point out if the username or the password is wrong as it uses a generic user not found message.
  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH", // enable the authentication tokens to be refreshed.
    "ALLOW_USER_PASSWORD_AUTH", // enable user authentication by username(in our case email) and password
    "ALLOW_ADMIN_USER_PASSWORD_AUTH" // enable user authentication with credentials created by the admin.
  ]
  
}

# resource "aws_cognito_user_pool_domain" "cognito-domain" {
#   domain       = "jokerandthekween"
#   user_pool_id = "${aws_cognito_user_pool.user_pool.id}"
# }