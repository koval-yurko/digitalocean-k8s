resource "kubernetes_deployment" "orders" {
  metadata {
    name      = "orders"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "orders"
      }
    }

    template {
      metadata {
        labels = {
          app = "orders"
        }
      }

      spec {
        container {
          name  = "orders"
          image = "failwin/orders:0.3.1"

          port {
            container_port = 3000
          }

          env {
            name  = "PAYMENTS_SERVICE_URL"
            value = "http://payments"
          }

          # env {
          #   name  = "OTEL_EXPORTER_OTLP_TRACES_ENDPOINT"
          #   value = "http://grafana-otlp-http.grafana.svc.cluster.local:4318/v1/traces"
          # }
          #
          # env {
          #   name  = "OTEL_EXPORTER_OTLP_METRICS_ENDPOINT"
          #   value = "http://grafana-otlp-http.grafana.svc.cluster.local:4318/v1/metrics"
          # }
          #
          # env {
          #   name  = "OTEL_DEBUG"
          #   value = "false"
          # }

          resources {
            limits = {
              cpu    = "150m"
              memory = "150Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "payments" {
  metadata {
    name      = "payments"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "payments"
      }
    }

    template {
      metadata {
        labels = {
          app = "payments"
        }
      }

      spec {
        container {
          name  = "payments"
          image = "failwin/payments:0.3.1"

          port {
            container_port = 3000
          }

          # env {
          #   name  = "OTEL_EXPORTER_OTLP_TRACES_ENDPOINT"
          #   value = "http://grafana-otlp-http.grafana.svc.cluster.local:4318/v1/traces"
          # }
          #
          # env {
          #   name  = "OTEL_EXPORTER_OTLP_METRICS_ENDPOINT"
          #   value = "http://grafana-otlp-http.grafana.svc.cluster.local:4318/v1/metrics"
          # }
          #
          # env {
          #   name  = "OTEL_DEBUG"
          #   value = "false"
          # }

          resources {
            limits = {
              cpu    = "150m"
              memory = "150Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "api-gateway" {
  metadata {
    name      = "api-gateway"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "api-gateway"
      }
    }

    template {
      metadata {
        labels = {
          app = "api-gateway"
        }
      }

      spec {
        container {
          name  = "api-gateway"
          image = "failwin/api-gateway:0.3.1"

          port {
            container_port = 3000
          }

          env {
            name  = "ORDERS_SERVICE_URL"
            value = "http://orders"
          }

          env {
            name  = "PAYMENTS_SERVICE_URL"
            value = "http://payments"
          }

          # env {
          #   name  = "OTEL_EXPORTER_OTLP_TRACES_ENDPOINT"
          #   value = "http://grafana-otlp-http.grafana.svc.cluster.local:4318/v1/traces"
          # }
          #
          # env {
          #   name  = "OTEL_EXPORTER_OTLP_METRICS_ENDPOINT"
          #   value = "http://grafana-otlp-http.grafana.svc.cluster.local:4318/v1/metrics"
          # }
          #
          # env {
          #   name  = "OTEL_DEBUG"
          #   value = "false"
          # }

          resources {
            limits = {
              cpu    = "150m"
              memory = "150Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}
