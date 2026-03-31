output "vault_secret_path" {
  description = "Vault KVv2 secret path backing the webpage content."
  value       = "${var.vault_kv_mount_path}/${var.vault_secret_path_prefix}/vso/webapp"
}

output "website_url" {
  description = "Demo webpage URL exposed through the Kubernetes ingress load balancer."
  value       = try("http://${kubernetes_ingress_v1.static_app.status[0].load_balancer[0].ingress[0].hostname}", "")
}
