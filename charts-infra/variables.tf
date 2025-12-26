
variable "digitalocean_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "root_domain" {
  description = "Root domain for the infrastructure"
  type        = string
}

variable "cluster_issuer_acme_email" {
  description = "ClusterIssuer acme email"
  type        = string
}

variable "redis_subdomain" {
  description = "Subdomain for Redis service"
  type        = string
  default     = "redis"
}
