provider "aws" {
  region = var.region
}

provider "cloudinit" {}

provider "kubernetes" {}

provider "kubernetes" {
  alias                  = "vso"
  host                   = try(module.eks_vso[0].cluster_endpoint, null)
  cluster_ca_certificate = try(base64decode(module.eks_vso[0].cluster_certificate_authority_data), null)
  token                  = try(data.aws_eks_cluster_auth.vso[0].token, null)
}

provider "kubernetes" {
  alias                  = "vso_csi"
  host                   = try(module.eks_vso_csi[0].cluster_endpoint, null)
  cluster_ca_certificate = try(base64decode(module.eks_vso_csi[0].cluster_certificate_authority_data), null)
  token                  = try(data.aws_eks_cluster_auth.vso_csi[0].token, null)
}

provider "helm" {}

provider "helm" {
  alias = "vso"

  kubernetes = {
    host                   = try(module.eks_vso[0].cluster_endpoint, null)
    cluster_ca_certificate = try(base64decode(module.eks_vso[0].cluster_certificate_authority_data), null)
    token                  = try(data.aws_eks_cluster_auth.vso[0].token, null)
  }
}

provider "helm" {
  alias = "vso_csi"

  kubernetes = {
    host                   = try(module.eks_vso_csi[0].cluster_endpoint, null)
    cluster_ca_certificate = try(base64decode(module.eks_vso_csi[0].cluster_certificate_authority_data), null)
    token                  = try(data.aws_eks_cluster_auth.vso_csi[0].token, null)
  }
}

provider "time" {}

provider "tls" {}

provider "local" {}

provider "random" {}

provider "vault" {
  address   = var.vault_address
  namespace = var.vault_namespace
}
