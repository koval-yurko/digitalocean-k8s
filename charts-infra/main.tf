resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "infra-ingress-nginx"
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
    name = "infra-cert-manager"
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
    name = "infra-external-dns"
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
      name  = "policy"
      value = "sync"
    },
    {
        name  = "domainFilters[0]"
        value = var.root_domain
    }
  ]

  set_sensitive = [
    {
      name  = "env[0].name"
      value = "DO_TOKEN"
    },
    {
      name  = "env[0].value"
      value = var.digitalocean_token
    }
  ]

  timeout = 600

  depends_on = [kubernetes_namespace.external_dns]
}

resource "kubernetes_manifest" "cluster_issuer" {
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    "metadata" = {
      "name" = "letsencrypt-prod"
    }
    "spec" = {
      "acme" = {
        "email" = var.cluster_issuer_acme_email
        "privateKeySecretRef" = {
          "name" = "letsencrypt-prod"
        }
        "server" = "https://acme-v02.api.letsencrypt.org/directory"
        "solvers" = [
          {
            "http01" = {
              "ingress" = {
                "class" = "nginx"
              }
            }
          }
        ]
      }
    }
  }

  depends_on = [helm_release.cert_manager, helm_release.external_dns]
}
