terraform {
  required_version = ">= 1.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
  }

  cloud {
    organization = "failwin"

    workspaces {
      project = "prj-yDudnkHkj9CpBs7Z"
      name = "digitalocean-k8s-charts-infra"
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

provider "kubernetes" {
  host                   = data.terraform_remote_state.cluster.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.cluster.outputs.cluster_ca_certificate)
  token                  = data.terraform_remote_state.cluster.outputs.cluster_token
}

provider "helm" {
  kubernetes = {
    host                   = data.terraform_remote_state.cluster.outputs.cluster_endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.cluster.outputs.cluster_ca_certificate)
    token                  = data.terraform_remote_state.cluster.outputs.cluster_token
  }
}
