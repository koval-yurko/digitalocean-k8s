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

resource "kubernetes_service" "payments" {
  metadata {
    name      = "payments"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  # api-gateway.dev.svc.cluster.local

  spec {
    selector = {
      app = kubernetes_deployment.payments.spec[0].template[0].metadata[0].labels["app"]
    }

    port {
      port        = 80
      target_port = 3000
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
      target_port = 3000
    }

    type = "ClusterIP"
  }
}
