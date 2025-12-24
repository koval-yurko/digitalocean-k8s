output "redis_password" {
  description = "Redis password for authentication"
  value       = var.redis_password
  sensitive   = true
}

output "redis_dns_name" {
  description = "DNS name for Redis service (auto-configured via external-dns)"
  value       = local.redis_url
}

output "redis_connection_string" {
  description = "Redis connection string using DNS name"
  value       = "redis://:${var.redis_password}@${local.redis_url}:6379"
  sensitive   = true
}

output "redis_internal_service" {
  description = "Internal Kubernetes service name for Redis"
  value       = "${kubernetes_service.redis.metadata[0].name}.${kubernetes_namespace.app.metadata[0].name}.svc.cluster.local"
}

output "namespace" {
  description = "Kubernetes namespace for Redis"
  value       = kubernetes_namespace.app.metadata[0].name
}