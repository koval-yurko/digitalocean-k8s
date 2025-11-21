resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"
  }
}

resource "helm_release" "ingress-nginx" {
  name = "ingress-nginx"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.14.0"
  namespace  = kubernetes_namespace.ingress_nginx.metadata[0].name

  set = [{
    name  = "controller.publishService.enabled"
    value = "true"
  }]
  timeout = 600

  depends_on = [kubernetes_namespace.ingress_nginx]
}

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  name = "cert-manager"

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.19.1"
  namespace  = kubernetes_namespace.cert_manager.metadata[0].name

  set = [{
    name  = "crds.enabled"
    value = "true"
  }]

  timeout = 600

  depends_on = [kubernetes_namespace.cert_manager, helm_release.ingress-nginx]
}

resource "kubernetes_namespace" "external_dns" {
  metadata {
    name = "external-dns"
  }
}

resource "helm_release" "external_dns" {
  name = "external-dns"

  repository = "https://kubernetes-sigs.github.io/external-dns"
  chart      = "external-dns"
  version    = "1.15.0"
  namespace  = kubernetes_namespace.external_dns.metadata[0].name

  set = [
    {
      name  = "provider.name"
      value = "digitalocean"
    },
    {
      name  = "digitalocean.apiToken"
      value = var.digitalocean_token
    },
    {
      name  = "policy"
      value = "sync"
    }
  ]

  timeout = 600

  depends_on = [kubernetes_namespace.external_dns]
}
