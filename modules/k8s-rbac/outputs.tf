output "oidc_binding_id" {
  description = "Identifier of the Kubernetes OIDC cluster role binding."
  value       = kubernetes_cluster_role_binding_v1.oidc_role.id
}