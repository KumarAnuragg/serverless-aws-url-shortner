provider "aws" {
  region = var.region
}

resource "aws_dynamodb_table" "short_links" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "shortId"

  attribute {
    name = "shortId"
    type = "S"
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-url-shortener-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "dynamodb_write_policy" {
  name = "lambda-dynamodb-write-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem"
        ],
        Resource = aws_dynamodb_table.short_links.arn
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_dynamodb_access" {
  name       = "lambda-dynamodb-access"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.dynamodb_write_policy.arn
}

resource "aws_lambda_function" "shorten_url" {
  function_name = "shorten-url"
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  filename         = "C:/Users/AK/aws-url-shortner/lambda/shorten-url/shorten-url.zip"
source_code_hash = filebase64sha256("C:/Users/AK/aws-url-shortner/lambda/shorten-url/shorten-url.zip")


  role = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      TABLE_NAME = var.table_name
    }
  }
}




resource "aws_apigatewayv2_api" "http_api" {
  name          = "url-shortener-api"
  protocol_type = "HTTP"
}



resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.shorten_url.invoke_arn
  integration_method = "POST"
  payload_format_version = "2.0"
}



resource "aws_apigatewayv2_route" "post_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}



resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "prod"
  auto_deploy = true
}



resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.shorten_url.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}



output "api_endpoint" {
  value = "${aws_apigatewayv2_api.http_api.api_endpoint}/prod/"
}



//Redirect-url config

resource "aws_lambda_function" "redirect_url" {
  function_name = "redirect-url"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  filename         = "C:/Users/AK/aws-url-shortner/lambda/redirect-url/redirect-url.zip"
source_code_hash = filebase64sha256("C:/Users/AK/aws-url-shortner/lambda/redirect-url/redirect-url.zip")

  environment {
    variables = {
      TABLE_NAME = var.table_name
    }
  }

  role = aws_iam_role.lambda_role.arn
}


//API Intergration
resource "aws_apigatewayv2_integration" "redirect_lambda_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.redirect_url.invoke_arn
  integration_method = "POST"
  payload_format_version = "2.0"
}


//Route for GET /{shortId}
resource "aws_apigatewayv2_route" "get_redirect_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /{shortId}"
  target    = "integrations/${aws_apigatewayv2_integration.redirect_lambda_integration.id}"
}


//Lambda Permission
resource "aws_lambda_permission" "allow_api_gateway_redirect" {
  statement_id  = "AllowAPIGatewayInvokeRedirect"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.redirect_url.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}



output "redirect_api_url" {
  value = "${aws_apigatewayv2_api.http_api.api_endpoint}/prod/{shortId}"
}

