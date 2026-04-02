module "k8s_addons_vso" {
  count  = var.enable_vso_cluster ? 1 : 0
  source = "./modules/aws-eks-addon"

  cluster_name                       = module.eks_vso[0].cluster_name
  vpc_id                             = module.vpc.vpc_id
  cluster_endpoint                   = module.eks_vso[0].cluster_endpoint
  cluster_version                    = module.eks_vso[0].cluster_version
  oidc_provider_arn                  = module.eks_vso[0].oidc_provider_arn
  cluster_certificate_authority_data = module.eks_vso[0].cluster_certificate_authority_data
  oidc_binding_id                    = module.k8s_rbac_vso[0].oidc_binding_id

  providers = {
    aws        = aws
    kubernetes = kubernetes.vso
    helm       = helm.vso
    time       = time
  }
}

module "k8s_addons_vso_csi" {
  count  = var.enable_vso_csi_cluster ? 1 : 0
  source = "./modules/aws-eks-addon"

  cluster_name                       = module.eks_vso_csi[0].cluster_name
  vpc_id                             = module.vpc.vpc_id
  cluster_endpoint                   = module.eks_vso_csi[0].cluster_endpoint
  cluster_version                    = module.eks_vso_csi[0].cluster_version
  oidc_provider_arn                  = module.eks_vso_csi[0].oidc_provider_arn
  cluster_certificate_authority_data = module.eks_vso_csi[0].cluster_certificate_authority_data
  oidc_binding_id                    = module.k8s_rbac_vso_csi[0].oidc_binding_id

  providers = {
    aws        = aws
    kubernetes = kubernetes.vso_csi
    helm       = helm.vso_csi
    time       = time
  }
}

module "k8s_edr_vso" {
  count  = var.enable_vso_cluster ? 1 : 0
  source = "./modules/k8s-edr-uptycs"

  cluster_name            = module.eks_vso[0].cluster_name
  namespace               = var.edr_namespace
  helm_repository         = var.edr_helm_repository
  helm_chart              = var.edr_helm_chart
  helm_chart_version      = var.edr_helm_chart_version
  additional_values_yaml  = var.edr_k8sosquery_values_yaml != "" ? [var.edr_k8sosquery_values_yaml] : []
  uptycs_tags             = var.edr_uptycs_tags
  cluster_readiness_token = module.k8s_rbac_vso[0].oidc_binding_id
  addons_dependency_token = tostring(length(keys(module.k8s_addons_vso[0].eks_addons)))

  providers = {
    kubernetes = kubernetes.vso
    helm       = helm.vso
  }
}

module "k8s_edr_vso_csi" {
  count  = var.enable_vso_csi_cluster ? 1 : 0
  source = "./modules/k8s-edr-uptycs"

  cluster_name            = module.eks_vso_csi[0].cluster_name
  namespace               = var.edr_namespace
  helm_repository         = var.edr_helm_repository
  helm_chart              = var.edr_helm_chart
  helm_chart_version      = var.edr_helm_chart_version
  additional_values_yaml  = var.edr_k8sosquery_values_yaml != "" ? [var.edr_k8sosquery_values_yaml] : []
  uptycs_tags             = var.edr_uptycs_tags
  cluster_readiness_token = module.k8s_rbac_vso_csi[0].oidc_binding_id
  addons_dependency_token = tostring(length(keys(module.k8s_addons_vso_csi[0].eks_addons)))

  providers = {
    kubernetes = kubernetes.vso_csi
    helm       = helm.vso_csi
  }
}
