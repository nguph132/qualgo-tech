# API Gateway HTTP API
resource "aws_apigatewayv2_api" "qualgo_api" {
  name          = "qualgo-api"
  protocol_type = "HTTP"
}

# Integration with EKS Backend
resource "aws_apigatewayv2_integration" "qualgo_api" {
  api_id             = aws_apigatewayv2_api.qualgo_api.id
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  integration_uri    = "${var.qualgo_backend_integration_uri}/students"
  # Forward headers (this includes the Host header)
  request_parameters = {
    "overwrite:header.Host" = "qualgo-api.internal"
  }
}

# Define the route for the get students API
resource "aws_apigatewayv2_route" "qualgo_api_route" {
  api_id    = aws_apigatewayv2_api.qualgo_api.id
  route_key = "ANY /students"
  target    = "integrations/${aws_apigatewayv2_integration.qualgo_api.id}"
}

resource "aws_apigatewayv2_stage" "qualgo_api" {
  name        = "qualgo"
  api_id      = aws_apigatewayv2_api.qualgo_api.id
  auto_deploy = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.qualgo_api.arn
    format = jsonencode({
      requestId         = "$context.requestId"
      ip                = "$context.identity.sourceIp"
      requestTime       = "$context.requestTime"
      httpMethod        = "$context.httpMethod"
      routeKey          = "$context.routeKey"
      status            = "$context.status"
      protocol          = "$context.protocol"
      responseLength    = "$context.responseLength"
      integrationStatus = "$context.integrationStatus"
    })
  }
}

resource "aws_cloudwatch_log_group" "qualgo_api" {
  name = "/aws/apigateway/qualgo-api"
}