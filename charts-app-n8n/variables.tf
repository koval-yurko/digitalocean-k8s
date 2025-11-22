variable "postgres_host" {
  description = "PostgreSQL database host"
  type        = string
}

variable "postgres_port" {
  description = "PostgreSQL database port"
  type        = string
  default     = "5432"
}

variable "postgres_database" {
  description = "PostgreSQL database name"
  type        = string
  default     = "n8n"
}

variable "postgres_user" {
  description = "PostgreSQL database user"
  type        = string
  default     = "n8n"
}

variable "postgres_password" {
  description = "PostgreSQL database password"
  type        = string
  sensitive   = true
}

variable "n8n_encryption_key" {
  description = "N8N encryption key for credentials"
  type        = string
  sensitive   = true
}

