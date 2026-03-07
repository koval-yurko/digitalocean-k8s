output "clickhouse_password" {
  description = "ClickHouse password for authentication"
  value       = var.clickhouse_password
  sensitive   = true
}

output "clickhouse_dns_name" {
  description = "DNS name for ClickHouse service (auto-configured via external-dns)"
  value       = local.clickhouse_url
}

output "clickhouse_connection_string" {
  description = "ClickHouse connection string using DNS name"
  value       = "clickhouse://${var.clickhouse_user}:${var.clickhouse_password}@${local.clickhouse_url}:9000/${var.clickhouse_db}"
  sensitive   = true
}

output "clickhouse_internal_service" {
  description = "Internal Kubernetes service name for ClickHouse"
  value       = "${kubernetes_service.clickhouse.metadata[0].name}.${kubernetes_namespace.app.metadata[0].name}.svc.cluster.local"
}

output "namespace" {
  description = "Kubernetes namespace for ClickHouse"
  value       = kubernetes_namespace.app.metadata[0].name
}