module "vault_integration_vso" {
  count  = local.enable_vault && var.enable_vso_cluster ? 1 : 0
  source = "./modules/vault-integration-bootstrap"

  cluster_name     = module.eks_vso[0].cluster_name
  integration_mode = "vso"
  namespace        = var.namespace_vso
  vault_address    = var.vault_address

  providers = {
    kubernetes = kubernetes.vso
    helm       = helm.vso
  }
}

module "vault_integration_vso_csi" {
  count  = local.enable_vault && var.enable_vso_csi_cluster ? 1 : 0
  source = "./modules/vault-integration-bootstrap"

  cluster_name     = module.eks_vso_csi[0].cluster_name
  integration_mode = "vso_csi"
  namespace        = var.namespace_vso_csi
  vault_address    = var.vault_address

  providers = {
    kubernetes = kubernetes.vso_csi
    helm       = helm.vso_csi
  }
}

module "vault_kv_mount" {
  count  = local.enable_vault ? 1 : 0
  source = "./modules/vault-kv-mount"

  mount_path = var.vault_kv_mount_path

  providers = {
    vault = vault
  }
}

module "vault_config_vso" {
  count  = local.enable_vault && var.enable_vso_cluster ? 1 : 0
  source = "./modules/vault-kubernetes-auth"

  cluster_name                       = module.eks_vso[0].cluster_name
  cluster_endpoint                   = module.eks_vso[0].cluster_endpoint
  cluster_certificate_authority_data = module.eks_vso[0].cluster_certificate_authority_data
  token_reviewer_jwt                 = var.vault_kubernetes_token_reviewer_jwt != "" ? var.vault_kubernetes_token_reviewer_jwt : data.aws_eks_cluster_auth.vso[0].token
  auth_path                          = var.vault_kubernetes_auth_path_vso
  kv_mount_path                      = var.vault_kv_mount_path
  secret_path_prefix                 = "${var.vault_secret_path_prefix}/${module.eks_vso[0].cluster_name}"
  vso_namespace                      = var.namespace_vso
  vso_service_account_name           = var.vso_service_account_name
  enable_csi_role                    = false

  providers = {
    vault = vault
  }

  depends_on = [module.vault_kv_mount]
}

module "vault_config_vso_csi" {
  count  = local.enable_vault && var.enable_vso_csi_cluster ? 1 : 0
  source = "./modules/vault-kubernetes-auth"

  cluster_name                       = module.eks_vso_csi[0].cluster_name
  cluster_endpoint                   = module.eks_vso_csi[0].cluster_endpoint
  cluster_certificate_authority_data = module.eks_vso_csi[0].cluster_certificate_authority_data
  token_reviewer_jwt                 = var.vault_kubernetes_token_reviewer_jwt != "" ? var.vault_kubernetes_token_reviewer_jwt : data.aws_eks_cluster_auth.vso_csi[0].token
  auth_path                          = var.vault_kubernetes_auth_path_vso_csi
  kv_mount_path                      = var.vault_kv_mount_path
  secret_path_prefix                 = "${var.vault_secret_path_prefix}/${module.eks_vso_csi[0].cluster_name}"
  vso_namespace                      = var.namespace_vso_csi
  vso_service_account_name           = var.vso_service_account_name
  enable_csi_role                    = true
  csi_service_account_name           = var.csi_service_account_name
  csi_service_account_namespace      = var.csi_service_account_namespace

  providers = {
    vault = vault
  }

  depends_on = [module.vault_kv_mount]
}
