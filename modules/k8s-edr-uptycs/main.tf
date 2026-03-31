locals {
  labels = {
    "app.kubernetes.io/managed-by"   = "terraform"
    "security.hashicorp.com/cluster" = var.cluster_name
    # Consume dependency tokens to guarantee execution ordering in the stack graph.
    "security.hashicorp.com/addons" = var.addons_dependency_token
    "security.hashicorp.com/rbac"   = var.cluster_readiness_token
  }
}

resource "kubernetes_namespace_v1" "edr" {
  metadata {
    name   = var.namespace
    labels = local.labels
  }
}

resource "helm_release" "uptycs_edr" {
  name             = "uptycs-edr"
  repository       = var.helm_repository
  chart            = var.helm_chart
  namespace        = kubernetes_namespace_v1.edr.metadata[0].name
  create_namespace = false
  wait             = true
  timeout          = 900
  version          = var.helm_chart_version != "" ? var.helm_chart_version : null

  values = concat([
    yamlencode({
      configmap = {
        name = "uptycs-config"
        data = {
          tags = var.uptycs_tags
        }
      }
    })
  ], var.additional_values_yaml)
}
