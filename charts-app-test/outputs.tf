output "api_gateway_url" {
  value       = local.api_gateway_url
  description = "API Gateway service URL"
}

output "payments_url" {
  value       = local.payments_url
  description = "Payments service URL"
}

output "orders_url" {
  value       = local.orders_url
  description = "Orders service URL"
}
