locals {
  vso_policy_name = "${var.cluster_name}-vso"
  csi_policy_name = "${var.cluster_name}-csi"

  vso_kv_data_path     = "${var.kv_mount_path}/data/${var.secret_path_prefix}/vso/*"
  vso_kv_metadata_path = "${var.kv_mount_path}/metadata/${var.secret_path_prefix}/vso/*"

  csi_kv_data_path     = "${var.kv_mount_path}/data/${var.secret_path_prefix}/csi/*"
  csi_kv_metadata_path = "${var.kv_mount_path}/metadata/${var.secret_path_prefix}/csi/*"
}

resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
  path = var.auth_path
}

resource "vault_kubernetes_auth_backend_config" "this" {
  backend                = vault_auth_backend.kubernetes.path
  kubernetes_host        = var.cluster_endpoint
  kubernetes_ca_cert     = base64decode(var.cluster_certificate_authority_data)
  token_reviewer_jwt     = var.token_reviewer_jwt
  disable_iss_validation = true
}

resource "vault_policy" "vso" {
  name = local.vso_policy_name

  policy = <<-EOT
    path "${local.vso_kv_data_path}" {
      capabilities = ["read"]
    }

    path "${local.vso_kv_metadata_path}" {
      capabilities = ["read", "list"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "vso" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = var.vso_role_name
  bound_service_account_names      = [var.vso_service_account_name]
  bound_service_account_namespaces = [var.vso_namespace]
  token_policies                   = [vault_policy.vso.name]
  token_ttl                        = var.token_ttl
  token_max_ttl                    = var.token_max_ttl
}

resource "vault_policy" "csi" {
  count = var.enable_csi_role ? 1 : 0

  name = local.csi_policy_name

  policy = <<-EOT
    path "${local.csi_kv_data_path}" {
      capabilities = ["read"]
    }

    path "${local.csi_kv_metadata_path}" {
      capabilities = ["read", "list"]
    }
  EOT
}

resource "vault_kubernetes_auth_backend_role" "csi" {
  count = var.enable_csi_role ? 1 : 0

  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = var.csi_role_name
  bound_service_account_names      = [var.csi_service_account_name]
  bound_service_account_namespaces = [var.csi_service_account_namespace]
  token_policies                   = [vault_policy.csi[0].name]
  token_ttl                        = var.token_ttl
  token_max_ttl                    = var.token_max_ttl
}
