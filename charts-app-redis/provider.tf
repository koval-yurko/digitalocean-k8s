terraform {
  required_version = ">= 1.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }

  cloud {
    organization = "failwin"

    workspaces {
      name = "digitalocean-k8s-charts-app-redis"
    }
  }
}

data "terraform_remote_state" "cluster" {
  backend = "remote"

  config = {
    organization = "failwin"
    workspaces = {
      name = "digitalocean-k8s-cluster"
    }
  }
}

data "terraform_remote_state" "charts-infra" {
  backend = "remote"

  config = {
    organization = "failwin"
    workspaces = {
      name = "digitalocean-k8s-charts-infra"
    }
  }
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.cluster.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.cluster.outputs.cluster_ca_certificate)
  token                  = data.terraform_remote_state.cluster.outputs.cluster_token
}