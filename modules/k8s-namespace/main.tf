resource "kubernetes_namespace_v1" "target" {
  metadata {
    labels = var.labels
    name   = var.namespace
  }
}
