module "k8s_rbac_vso" {
  count  = var.enable_vso_cluster ? 1 : 0
  source = "./modules/k8s-rbac"

  cluster_endpoint      = module.eks_vso[0].cluster_endpoint
  tfc_organization_name = var.tfc_organization_name

  providers = {
    kubernetes = kubernetes.vso
    time       = time
  }
}

module "k8s_rbac_vso_csi" {
  count  = var.enable_vso_csi_cluster ? 1 : 0
  source = "./modules/k8s-rbac"

  cluster_endpoint      = module.eks_vso_csi[0].cluster_endpoint
  tfc_organization_name = var.tfc_organization_name

  providers = {
    kubernetes = kubernetes.vso_csi
    time       = time
  }
}

module "k8s_namespace_vso" {
  count  = var.enable_vso_cluster ? 1 : 0
  source = "./modules/k8s-namespace"

  namespace = var.namespace_vso
  labels = {
    addons-count = tostring(length(keys(module.k8s_addons_vso[0].eks_addons)))
  }

  providers = {
    kubernetes = kubernetes.vso
  }
}

module "k8s_namespace_vso_csi" {
  count  = var.enable_vso_csi_cluster ? 1 : 0
  source = "./modules/k8s-namespace"

  namespace = var.namespace_vso_csi
  labels = {
    addons-count = tostring(length(keys(module.k8s_addons_vso_csi[0].eks_addons)))
  }

  providers = {
    kubernetes = kubernetes.vso_csi
  }
}
