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
