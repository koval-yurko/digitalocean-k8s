resource "kubernetes_deployment" "worker" {
  metadata {
    name      = "worker"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "worker"
      }
    }

    template {
      metadata {
        labels = {
          app = "worker"
        }
      }

      spec {
        container {
          name  = "worker"
          image = "failwin/celery-example-worker:0.0.5"

          env {
            name  = "REDIS_BROKER_URL"
            value = var.redis_broker_url
          }

          env {
            name  = "REDIS_RESULT_BACKEND"
            value = var.redis_result_backend
          }

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

resource "kubernetes_deployment" "service-1" {
  metadata {
    name      = "service-1"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "service-1"
      }
    }

    template {
      metadata {
        labels = {
          app = "service-1"
        }
      }

      spec {
        container {
          name  = "service-1"
          image = "failwin/celery-example-service-1:0.0.5"

          port {
            container_port = 8000
          }

          env {
            name  = "REDIS_BROKER_URL"
            value = var.redis_broker_url
          }

          env {
            name  = "REDIS_RESULT_BACKEND"
            value = var.redis_result_backend
          }

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

resource "kubernetes_deployment" "service-2" {
  metadata {
    name      = "service-2"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "service-2"
      }
    }

    template {
      metadata {
        labels = {
          app = "service-2"
        }
      }

      spec {
        container {
          name  = "service-2"
          image = "failwin/celery-example-service-2:0.0.5"

          port {
            container_port = 8000
          }

          env {
            name  = "REDIS_BROKER_URL"
            value = var.redis_broker_url
          }

          env {
            name  = "REDIS_RESULT_BACKEND"
            value = var.redis_result_backend
          }

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
          image = "failwin/celery-example-api-gateway:0.0.5"

          port {
            container_port = 8000
          }

          env {
            name  = "SERVICE1_URL"
            value = "http://service-1"
          }

          env {
            name  = "SERVICE2_URL"
            value = "http://service-2"
          }

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
