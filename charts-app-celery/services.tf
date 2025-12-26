resource "kubernetes_service" "service-1" {
  metadata {
    name      = "service-1"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  # api-gateway.dev.svc.cluster.local

  spec {
    selector = {
      app = kubernetes_deployment.service-1.spec[0].template[0].metadata[0].labels["app"]
    }

    port {
      port        = 80
      target_port = 8000
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "service-2" {
  metadata {
    name      = "service-2"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  # api-gateway.dev.svc.cluster.local

  spec {
    selector = {
      app = kubernetes_deployment.service-1.spec[0].template[0].metadata[0].labels["app"]
    }

    port {
      port        = 80
      target_port = 8000
    }

    type = "ClusterIP"
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
      app = kubernetes_deployment.api-gateway.spec[0].template[0].metadata[0].labels["app"]
    }

    port {
      port        = 80
      target_port = 8000
    }

    type = "ClusterIP"
  }
}
