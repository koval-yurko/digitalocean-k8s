resource "kubernetes_namespace" "app" {
  metadata {
    name = "app-redis"
  }
}

resource "kubernetes_deployment" "redis" {
  metadata {
    name      = "redis"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "redis"
      }
    }

    template {
      metadata {
        labels = {
          app = "redis"
        }
      }

      spec {
        container {
          name  = "redis"
          image = "redis:7-alpine"

          command = ["redis-server"]
          args    = ["--requirepass", "$(REDIS_PASSWORD)"]

          port {
            name           = "redis"
            container_port = 6379
            protocol       = "TCP"
          }

          env {
            name  = "REDIS_PASSWORD"
            value = var.redis_password
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }

          liveness_probe {
            exec {
              command = ["redis-cli", "ping"]
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          readiness_probe {
            exec {
              command = ["redis-cli", "ping"]
            }
            initial_delay_seconds = 5
            period_seconds        = 5
            timeout_seconds       = 3
            failure_threshold     = 3
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "redis" {
  metadata {
    name      = "redis"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    selector = {
      app = kubernetes_deployment.redis.spec[0].template[0].metadata[0].labels["app"]
    }

    port {
      name        = "redis"
      port        = 6379
      target_port = 6379
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}

# Note: Redis DNS is configured via external-dns annotation on the
# ingress-nginx-controller Service in charts-infra, not via an Ingress resource.
# Redis uses TCP protocol (layer 4), while Ingress is for HTTP/HTTPS (layer 7).
# Redis is exposed via TCP passthrough on the ingress controller LoadBalancer.
