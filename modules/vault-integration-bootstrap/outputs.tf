output "integration_mode" {
  description = "Integration mode deployed in this cluster."
  value       = var.integration_mode
}

output "namespace" {
  description = "Namespace where Vault integration components are deployed."
  value       = kubernetes_namespace_v1.vault_integration.metadata[0].name
}

output "vault_address" {
  description = "Vault address configured for the integration bootstrap."
  value       = var.vault_address
}
