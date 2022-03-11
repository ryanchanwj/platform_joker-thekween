// Resources
resource "aws_cognito_user_pool" "user_pool" {
  name = "customers"

 account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  alias_attributes = ["email"]
  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length = 6
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject = "Account Confirmation"
    email_message = "Your confirmation code is {####}"
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  lambda_config {
    post_confirmation = module.lambda_cross_region.invoke_arn
  }
  depends_on = [
    module.lambda_cross_region.invoke_arn
  ]
}

resource "aws_cognito_user_pool_client" "client" {
  name = "tokyo-customer-client"

  user_pool_id = aws_cognito_user_pool.user_pool.id
  generate_secret = false
  refresh_token_validity = 90
  prevent_user_existence_errors = "ENABLED" //error message to not point out if the username or the password is wrong as it uses a generic user not found message.
  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH", // enable the authentication tokens to be refreshed.
    # "ALLOW_USER_PASSWORD_AUTH", // enable user authentication by username(in our case email) and password, enabling this makes the username ryanchan-at-hotmail.com prevents login for wildrydes
    # "ALLOW_ADMIN_USER_PASSWORD_AUTH" // enable user authentication with credentials created by the admin.
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_CUSTOM_AUTH",
  ]

  allowed_oauth_flows = ["implicit"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes = ["openid", "profile", "email"]
  callback_urls = ["https://${data.aws_cloudfront_distribution.www.domain_name}"]
  logout_urls = ["https://${data.aws_cloudfront_distribution.www.domain_name}/_identity/logout"]
  supported_identity_providers = ["COGNITO"]
}

resource "aws_cognito_user_pool_domain" "cognito-domain" {
  domain       = "authhk.jokerandthekween.click" // Unable to delete old ACM cert, stuck with hk domain
  user_pool_id = "${aws_cognito_user_pool.user_pool.id}"
  certificate_arn = data.aws_acm_certificate.cert.arn
}