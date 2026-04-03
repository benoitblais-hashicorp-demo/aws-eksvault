required_providers {
  aws = {
    source  = "hashicorp/aws"
    version = "~> 6.28"
  }

  cloudinit = {
    source  = "hashicorp/cloudinit"
    version = "~> 2.0"
  }

  kubernetes = {
    source  = "hashicorp/kubernetes"
    version = "~> 2.25"
  }

  time = {
    source = "hashicorp/time"
    version = "~> 0.1"
  }
  
  tls = {
    source = "hashicorp/tls"
    version = "~> 4.0"
  }

  helm = {
    source = "hashicorp/helm"
    version = "~> 2.12"
  }

  local = {
    source = "hashicorp/local"
    version = "~> 2.4"
  }

  null = {
    source  = "hashicorp/null"
    version = "~> 3.2"
  }

  random = {
    source = "hashicorp/random"
    version = "~> 3.7.0"
  }

  vault = {
    source  = "hashicorp/vault"
    version = "5.8.0"
  }
}

provider "aws" "configurations" {
  config {
    region = var.region

    assume_role_with_web_identity {
      role_arn           = var.role_arn
      web_identity_token = var.aws_identity_token
    }
  }
}

provider "kubernetes" "vso_configurations" {
  config { 
    host                   = component.eks_vso.cluster_endpoint
    cluster_ca_certificate = base64decode(component.eks_vso.cluster_certificate_authority_data)
    token                  = component.eks_vso.eks_token
  }
}

provider "kubernetes" "vso_csi_configurations" {
  config { 
    host                   = component.eks_vso_csi.cluster_endpoint
    cluster_ca_certificate = base64decode(component.eks_vso_csi.cluster_certificate_authority_data)
    token                  = component.eks_vso_csi.eks_token
  }
}
/*
provider "kubernetes" "vso_oidc_configurations" {
  config {
    host                   = component.eks_vso.cluster_endpoint
    cluster_ca_certificate = base64decode(component.eks_vso.cluster_certificate_authority_data)
    token                  = var.k8s_identity_token
  }
}

provider "kubernetes" "vso_csi_oidc_configurations" {
  config {
    host                   = component.eks_vso_csi.cluster_endpoint
    cluster_ca_certificate = base64decode(component.eks_vso_csi.cluster_certificate_authority_data)
    token                  = var.k8s_identity_token
  }
}

provider "helm" "vso_oidc_configurations" {
  config {
    kubernetes {
      host                   = component.eks_vso.cluster_endpoint
      cluster_ca_certificate = base64decode(component.eks_vso.cluster_certificate_authority_data)
      token                  = var.k8s_identity_token
    }
  }
}

provider "helm" "vso_csi_oidc_configurations" {
  config {
    kubernetes {
      host                   = component.eks_vso_csi.cluster_endpoint
      cluster_ca_certificate = base64decode(component.eks_vso_csi.cluster_certificate_authority_data)
      token                  = var.k8s_identity_token
    }
  }

}
*/
provider "cloudinit" "this" {}

provider "kubernetes" "this" {}

provider "time" "this" {}

provider "tls" "this" {}

provider "local" "this" {}

provider "null" "this" {}

provider "random" "this" {}

provider "vault" "this" {
  config {
    address          = var.vault_address
    namespace        = var.vault_namespace
    skip_child_token = true
    
    auth_login_jwt {
      mount = var.vault_provider_auth_path
      role  = var.vault_run_role
      jwt   = var.vault_identity_token
    }
  }
}
