output "api_gateway_endpoint" {
  value       = aws_apigatewayv2_api.qualgo_api.api_endpoint
  description = "The endpoint URL for the API Gateway"
}