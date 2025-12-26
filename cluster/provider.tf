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
      project = "prj-yDudnkHkj9CpBs7Z"
      name = "digitalocean-k8s-cluster"
    }
  }
}

provider "digitalocean" {
  token = var.digitalocean_token
}
