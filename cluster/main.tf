# VPC for the Kubernetes cluster
resource "digitalocean_vpc" "main" {
  name        = "digitalocean-k8s-vpc"
  region      = "fra1"
  ip_range    = var.vpc_ip_range
  description = "VPC for DigitalOcean Kubernetes cluster"
}

resource "digitalocean_kubernetes_cluster" "main" {
  name         = "digitalocean-k8s-cluster"
  region       = "fra1"
  version      = "1.34.1-do.0"
  vpc_uuid     = digitalocean_vpc.main.id
  auto_upgrade = true

  node_pool {
    name       = "digitalocean-k8s-cluster-worker-pool"
    size       = "s-2vcpu-4gb"
    node_count = 1
    tags       = ["digitalocean-k8s"]
    auto_scale = false
  }
}
