
variable "digitalocean_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "root_domain" {
  description = "Root domain for the infrastructure"
  type        = string
}
