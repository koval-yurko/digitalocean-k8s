variable "clickhouse_password" {
  description = "Password for ClickHouse authentication"
  type        = string
  sensitive   = true
}

variable "clickhouse_db" {
  description = "ClickHouse database name"
  type        = string
  default     = "db"
}

variable "clickhouse_user" {
  description = "ClickHouse user name"
  type        = string
  default     = "clickhouse"
}
