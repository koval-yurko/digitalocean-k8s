terraform {
  required_version = ">= 1.0"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  cloud {
    organization = "failwin"

    workspaces {
      name = "digitalocean-k8s-cluster"
    }
  }
}

provider "digitalocean" {
  token = var.digitalocean_token
}
