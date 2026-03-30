output "auth_path" {
  description = "Kubernetes auth backend path configured in Vault."
  value       = vault_auth_backend.kubernetes.path
}

output "csi_role_name" {
  description = "CSI Vault role name when enabled."
  value       = var.enable_csi_role ? vault_kubernetes_auth_backend_role.csi[0].role_name : null
}

output "kv_mount_path" {
  description = "KVv2 mount path used by Vault policies."
  value       = var.kv_mount_path
}

output "vso_role_name" {
  description = "VSO Vault role name."
  value       = vault_kubernetes_auth_backend_role.vso.role_name
}
