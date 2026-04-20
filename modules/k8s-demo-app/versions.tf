terraform {

  required_version = "~> 1.14"

  required_providers {

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.8"
    }

    time = {
      source  = "hashicorp/time"
      version = "~> 0.1"
    }

  }
}
