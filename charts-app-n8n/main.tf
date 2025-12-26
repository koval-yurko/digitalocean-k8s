resource "kubernetes_namespace" "app" {
  metadata {
    name = "app-n8n"
  }
}

# resource "helm_release" "n8n" {
#   name = "n8n"
#
#   repository = "oci://8gears.container-registry.com/library"
#   chart      = "n8n"
#   version    = "1.0.0"
#   namespace  = kubernetes_namespace.app.metadata[0].name
#
#   # Image configuration
#   set = [
#     {
#       name  = "image.repository"
#       value = "n8nio/n8n"
#     },
#     {
#       name  = "image.tag"
#       value = "1.121.2"
#     },
#     {
#       name  = "image.pullPolicy"
#       value = "IfNotPresent"
#     },
#     # Ingress configuration
#     {
#       name  = "ingress.enabled"
#       value = "true"
#     },
#     {
#       name  = "ingress.className"
#       value = "nginx"
#     },
#     {
#       name  = "ingress.hosts[0].host"
#       value = local.n8n_url
#     },
#     {
#       name  = "ingress.hosts[0].paths[0]"
#       value = "/"
#     },
#     {
#       name  = "ingress.tls[0].hosts[0]"
#       value = local.n8n_url
#     },
#     {
#       name  = "ingress.tls[0].secretName"
#       value = local.cluster_issuer_name
#     },
#     {
#       name  = "ingress.annotations.cert-manager\\.io/cluster-issuer"
#       value = local.cluster_issuer_name
#     },
#     {
#       name  = "ingress.annotations.external-dns\\.alpha\\.kubernetes\\.io/hostname"
#       value = local.n8n_url
#     },
#     {
#       name  = "ingress.annotations.kubernetes\\.io/ingress\\.class"
#       value = "nginx"
#     },
#     # Database configuration - PostgreSQL
#     {
#       name  = "main.config.DB_TYPE"
#       value = "postgresdb"
#     },
#     {
#       name  = "main.config.DB_POSTGRESDB_HOST"
#       value = var.postgres_host
#     },
#     {
#       name  = "main.config.DB_POSTGRESDB_PORT"
#       value = var.postgres_port
#     },
#     {
#       name  = "main.config.DB_POSTGRESDB_DATABASE"
#       value = var.postgres_database
#     },
#     {
#       name  = "main.config.DB_POSTGRESDB_USER"
#       value = var.postgres_user
#     },
#     {
#       name  = "main.config.DB_POSTGRESDB_SSL_ENABLED"
#       value = "true"
#     },
#     {
#       name  = "main.config.DB_POSTGRESDB_SSL_REJECT_UNAUTHORIZED"
#       value = "false"
#     },
#     # N8N Configuration - Security & Future-proofing
#     {
#       name  = "main.config.N8N_RUNNERS_ENABLED"
#       value = "true"
#     },
#     {
#       name  = "main.config.N8N_BLOCK_ENV_ACCESS_IN_NODE"
#       value = "false"
#     },
#     {
#       name  = "main.config.N8N_GIT_NODE_DISABLE_BARE_REPOS"
#       value = "true"
#     },
#     {
#       name  = "main.config.N8N_EDITOR_BASE_URL"
#       value = "https://${local.n8n_url}"
#     },
#     {
#       name  = "main.config.N8N_WEBHOOK_URL"
#       value = "https://${local.n8n_url}"
#     },
#     # Main service configuration
#     {
#       name  = "main.service.type"
#       value = "ClusterIP"
#     },
#     {
#       name  = "main.service.port"
#       value = "80"
#     },
#     # Persistence configuration
#     {
#       name  = "main.persistence.enabled"
#       value = "true"
#     },
#     {
#       name  = "main.persistence.type"
#       value = "dynamic"
#     },
#     {
#       name  = "main.persistence.size"
#       value = "2Gi"
#     },
#     {
#       name  = "main.persistence.accessModes[0]"
#       value = "ReadWriteOnce"
#     },
#     # Resource limits and requests
#     {
#       name  = "main.resources.limits.cpu"
#       value = "500m"
#     },
#     {
#       name  = "main.resources.limits.memory"
#       value = "1024Mi"
#     },
#     {
#       name  = "main.resources.requests.cpu"
#       value = "250m"
#     },
#     {
#       name  = "main.resources.requests.memory"
#       value = "768Mi"
#     }
#   ]
#
#   set_sensitive = [
#     {
#       name  = "main.secret.DB_POSTGRESDB_PASSWORD"
#       value = var.postgres_password
#     },
#     {
#       name  = "main.secret.N8N_ENCRYPTION_KEY"
#       value = var.n8n_encryption_key
#     }
#   ]
#
#   timeout = 400
#
#   depends_on = [kubernetes_namespace.app]
# }

resource "helm_release" "n8n_my" {
  name = "n8n-my"

  repository = "oci://8gears.container-registry.com/library"
  chart      = "n8n"
  version    = "1.0.0"
  namespace  = kubernetes_namespace.app.metadata[0].name

  # Image configuration
  set = [
    {
      name  = "image.repository"
      value = "failwin/my-n8n"
    },
    {
      name  = "image.tag"
      value = "1.121.1-own-3-amd64"
    },
    {
      name  = "image.pullPolicy"
      value = "IfNotPresent"
    },
    # Ingress configuration
    {
      name  = "ingress.enabled"
      value = "true"
    },
    {
      name  = "ingress.className"
      value = "nginx"
    },
    {
      name  = "ingress.hosts[0].host"
      value = local.n8n_my_url
    },
    {
      name  = "ingress.hosts[0].paths[0]"
      value = "/"
    },
    {
      name  = "ingress.tls[0].hosts[0]"
      value = local.n8n_my_url
    },
    {
      name  = "ingress.tls[0].secretName"
      value = "${local.cluster_issuer_name}-n8n-my"
    },
    {
      name  = "ingress.annotations.cert-manager\\.io/cluster-issuer"
      value = local.cluster_issuer_name
    },
    {
      name  = "ingress.annotations.external-dns\\.alpha\\.kubernetes\\.io/hostname"
      value = local.n8n_my_url
    },
    {
      name  = "ingress.annotations.kubernetes\\.io/ingress\\.class"
      value = "nginx"
    },
    # Database configuration - PostgreSQL
    {
      name  = "main.config.DB_TYPE"
      value = "postgresdb"
    },
    {
      name  = "main.config.DB_POSTGRESDB_HOST"
      value = var.postgres_host
    },
    {
      name  = "main.config.DB_POSTGRESDB_PORT"
      value = var.postgres_port
    },
    {
      name  = "main.config.DB_POSTGRESDB_DATABASE"
      value = var.postgres_database
    },
    {
      name  = "main.config.DB_POSTGRESDB_USER"
      value = var.postgres_user
    },
    {
      name  = "main.config.DB_POSTGRESDB_SSL_ENABLED"
      value = "true"
    },
    {
      name  = "main.config.DB_POSTGRESDB_SSL_REJECT_UNAUTHORIZED"
      value = "false"
    },
    # N8N Configuration - Security & Future-proofing
    {
      name  = "main.config.N8N_RUNNERS_ENABLED"
      value = "true"
    },
    {
      name  = "main.config.N8N_BLOCK_ENV_ACCESS_IN_NODE"
      value = "false"
    },
    {
      name  = "main.config.N8N_GIT_NODE_DISABLE_BARE_REPOS"
      value = "true"
    },
    {
      name  = "main.config.N8N_EDITOR_BASE_URL"
      value = "https://${local.n8n_my_url}"
    },
    {
      name  = "main.config.N8N_WEBHOOK_URL"
      value = "https://${local.n8n_my_url}"
    },
    # Main service configuration
    {
      name  = "main.service.type"
      value = "ClusterIP"
    },
    {
      name  = "main.service.port"
      value = "80"
    },
    # Persistence configuration
    {
      name  = "main.persistence.enabled"
      value = "true"
    },
    {
      name  = "main.persistence.type"
      value = "dynamic"
    },
    {
      name  = "main.persistence.size"
      value = "2Gi"
    },
    {
      name  = "main.persistence.accessModes[0]"
      value = "ReadWriteOnce"
    },
    # Resource limits and requests
    {
      name  = "main.resources.limits.cpu"
      value = "500m"
    },
    {
      name  = "main.resources.limits.memory"
      value = "1024Mi"
    },
    {
      name  = "main.resources.requests.cpu"
      value = "250m"
    },
    {
      name  = "main.resources.requests.memory"
      value = "768Mi"
    }
  ]

  set_sensitive = [
    {
      name  = "main.secret.DB_POSTGRESDB_PASSWORD"
      value = var.postgres_password
    },
    {
      name  = "main.secret.N8N_ENCRYPTION_KEY"
      value = var.n8n_encryption_key
    }
  ]

  timeout = 400

  depends_on = [kubernetes_namespace.app]
}
