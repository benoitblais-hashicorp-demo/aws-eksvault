output "namespace" {
  description = "Name of the created Kubernetes namespace."
  value       = kubernetes_namespace_v1.target.metadata[0].name
}
