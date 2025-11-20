
variable "digitalocean_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "vpc_ip_range" {
  description = "IP range for the VPC network in CIDR notation"
  type        = string
  default     = "10.10.0.0/18"
}
