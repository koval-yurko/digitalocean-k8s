output "root_domain" {
  value       = var.root_domain
  description = "Root domain for the infrastructure"
}

output "cluster_issuer_name" {
  value       = kubernetes_manifest.cluster_issuer.manifest.metadata.name
  description = "ClusterIssuer name"
}
