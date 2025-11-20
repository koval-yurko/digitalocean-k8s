output "cluster_endpoint" {
  value       = digitalocean_kubernetes_cluster.main.endpoint
  description = "Kubernetes cluster endpoint"
}

output "cluster_ca_certificate" {
  value       = digitalocean_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate
  sensitive   = true
  description = "Kubernetes cluster CA certificate (base64 encoded)"
}

output "cluster_token" {
  value       = digitalocean_kubernetes_cluster.main.kube_config[0].token
  sensitive   = true
  description = "Kubernetes cluster authentication token"
}

output "cluster_id" {
  value       = digitalocean_kubernetes_cluster.main.id
  description = "Kubernetes cluster ID"
}

output "cluster_name" {
  value       = digitalocean_kubernetes_cluster.main.name
  description = "Kubernetes cluster name"
}

output "vpc_id" {
  value       = digitalocean_vpc.main.id
  description = "VPC ID"
}

output "vpc_ip_range" {
  value       = digitalocean_vpc.main.ip_range
  description = "VPC IP range"
}