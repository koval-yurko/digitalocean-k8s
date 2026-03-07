resource "kubernetes_namespace" "app" {
  metadata {
    name = "app-clickhouse"
  }
}

resource "kubernetes_deployment" "clickhouse" {
  timeouts {
    create = "5m"
  }

  metadata {
    name      = "clickhouse"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "clickhouse"
      }
    }

    template {
      metadata {
        labels = {
          app = "clickhouse"
        }
      }

      spec {
        security_context {
          run_as_user  = 101
          run_as_group = 101
        }

        container {
          name  = "clickhouse"
          image = "docker.io/clickhouse/clickhouse-server"

          port {
            name           = "http"
            container_port = 8123
            protocol       = "TCP"
          }

          port {
            name           = "native"
            container_port = 9000
            protocol       = "TCP"
          }

          env {
            name  = "CLICKHOUSE_DB"
            value = var.clickhouse_db
          }

          env {
            name  = "CLICKHOUSE_USER"
            value = var.clickhouse_user
          }

          env {
            name  = "CLICKHOUSE_PASSWORD"
            value = var.clickhouse_password
          }

          volume_mount {
            name       = "clickhouse-data"
            mount_path = "/var/lib/clickhouse"
          }

          volume_mount {
            name       = "clickhouse-logs"
            mount_path = "/var/log/clickhouse-server"
          }

          liveness_probe {
            http_get {
              path = "/ping"
              port = 8123
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/ping"
              port = 8123
            }
            initial_delay_seconds = 10
            period_seconds        = 5
            timeout_seconds       = 3
            failure_threshold     = 3
          }

          resources {
            limits = {
              cpu    = "1100m"
              memory = "2.1Gi"
            }
            requests = {
              cpu    = "1000m"
              memory = "2.0Gi"
            }
          }
        }

        volume {
          name = "clickhouse-data"
          empty_dir {}
        }

        volume {
          name = "clickhouse-logs"
          empty_dir {}
        }
      }
    }
  }
}

resource "kubernetes_service" "clickhouse" {
  metadata {
    name      = "clickhouse"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_deployment.clickhouse.spec[0].template[0].metadata[0].labels["app"]
    }

    port {
      name        = "http"
      port        = 8123
      target_port = 8123
      protocol    = "TCP"
    }

    port {
      name        = "native"
      port        = 9000
      target_port = 9000
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}
