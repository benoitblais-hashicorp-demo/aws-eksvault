module "k8s_demo_app_vso" {
  count  = local.deploy_demo && var.enable_vso_cluster ? 1 : 0
  source = "./modules/k8s-demo-app"

  app_namespace                = module.vault_integration_vso[0].namespace
  integration_dependency_token = module.vault_integration_vso[0].vso_release_revision
  demo_app_image               = var.demo_webapp_image
  vault_address                = var.vault_address
  vault_auth_path              = module.vault_config_vso[0].auth_path
  vault_auth_role              = module.vault_config_vso[0].vso_role_name
  vault_kv_mount_path          = var.vault_kv_mount_path
  vault_secret_path_prefix     = "${var.vault_secret_path_prefix}/${module.eks_vso[0].cluster_name}"
  vso_service_account_name     = var.vso_service_account_name

  providers = {
    helm       = helm.vso
    kubernetes = kubernetes.vso
    time       = time
    vault      = vault
  }
}

module "k8s_demo_app_vso_csi" {
  count  = local.deploy_demo && var.enable_vso_csi_cluster ? 1 : 0
  source = "./modules/k8s-demo-app"

  app_namespace                = module.vault_integration_vso_csi[0].namespace
  integration_dependency_token = module.vault_integration_vso_csi[0].vso_release_revision
  demo_app_image               = var.demo_webapp_image
  vault_address                = var.vault_address
  vault_auth_path              = module.vault_config_vso_csi[0].auth_path
  vault_auth_role              = module.vault_config_vso_csi[0].vso_role_name
  vault_kv_mount_path          = var.vault_kv_mount_path
  vault_secret_path_prefix     = "${var.vault_secret_path_prefix}/${module.eks_vso_csi[0].cluster_name}"
  vso_service_account_name     = var.vso_service_account_name

  providers = {
    helm       = helm.vso_csi
    kubernetes = kubernetes.vso_csi
    time       = time
    vault      = vault
  }
}
