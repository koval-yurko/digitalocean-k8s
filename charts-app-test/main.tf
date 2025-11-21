resource "kubernetes_namespace" "app" {
  metadata {
    name = "app-test"
  }
}

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
            value = "http://${local.payments_url}"
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

resource "kubernetes_service" "orders" {
  metadata {
    name      = "orders"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  # api-gateway.dev.svc.cluster.local

  spec {
    selector = {
      app = kubernetes_deployment.orders.spec[0].template[0].metadata[0].labels["app"]
    }

    port {
      port        = 80
      target_port = 3000
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "orders" {
  metadata {
    name = "orders"
    namespace = kubernetes_namespace.app.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      # "cert-manager.io/cluster-issuer" = local.cluster_issuer_name
    }
  }

  spec {
    rule {
      host = local.orders_url
      http {
        path {
          path     = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.orders.metadata[0].name
              port {
                number = kubernetes_service.orders.spec[0].port[0].port
              }
            }
          }
        }
      }
    }

    # tls {
    #   hosts = [local.orders_url]
    #   secret_name = local.cluster_issuer_name
    # }
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

resource "kubernetes_service" "payments" {
  metadata {
    name      = "payments"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  # api-gateway.dev.svc.cluster.local

  spec {
    selector = {
      app = kubernetes_deployment.orders.spec[0].template[0].metadata[0].labels["app"]
    }

    port {
      port        = 80
      target_port = 3000
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "payments" {
  metadata {
    name = "payments"
    namespace = kubernetes_namespace.app.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      # "cert-manager.io/cluster-issuer" = local.cluster_issuer_name
    }
  }

  spec {
    rule {
      host = local.payments_url
      http {
        path {
          path     = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.orders.metadata[0].name
              port {
                number = kubernetes_service.orders.spec[0].port[0].port
              }
            }
          }
        }
      }
    }

    # tls {
    #   hosts = [local.orders_url]
    #   secret_name = local.cluster_issuer_name
    # }
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
            value = "http://${local.orders_url}"
          }

          env {
            name  = "PAYMENTS_SERVICE_URL"
            value = "http://${local.payments_url}"
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

resource "kubernetes_service" "api-gateway" {
  metadata {
    name      = "api-gateway"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  # api-gateway.dev.svc.cluster.local

  spec {
    selector = {
      app = kubernetes_deployment.orders.spec[0].template[0].metadata[0].labels["app"]
    }

    port {
      port        = 80
      target_port = 3000
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "api-gateway" {
  metadata {
    name = "api-gateway"
    namespace = kubernetes_namespace.app.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      # "cert-manager.io/cluster-issuer" = local.cluster_issuer_name
    }
  }

  spec {
    rule {
      host = local.api_gateway_url
      http {
        path {
          path     = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.orders.metadata[0].name
              port {
                number = kubernetes_service.orders.spec[0].port[0].port
              }
            }
          }
        }
      }
    }

    # tls {
    #   hosts = [local.orders_url]
    #   secret_name = local.cluster_issuer_name
    # }
  }
}
