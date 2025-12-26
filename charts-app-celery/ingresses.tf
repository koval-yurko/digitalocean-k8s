resource "kubernetes_ingress_v1" "api-gateway" {
  metadata {
    name = "api-gateway"
    namespace = kubernetes_namespace.app.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "cert-manager.io/cluster-issuer" = local.cluster_issuer_name
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
              name = kubernetes_service.api-gateway.metadata[0].name
              port {
                number = kubernetes_service.api-gateway.spec[0].port[0].port
              }
            }
          }
        }
      }
    }

    tls {
      hosts = [local.api_gateway_url]
      secret_name = local.cluster_issuer_name
    }
  }
}
