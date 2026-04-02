locals {
  enable_vault = trimspace(var.vault_address) != ""
  deploy_demo  = local.enable_vault && trimspace(var.demo_webapp_image) != ""
}
