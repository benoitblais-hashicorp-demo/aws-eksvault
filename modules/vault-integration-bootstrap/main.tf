locals {
  labels = {
    "app.kubernetes.io/managed-by" = "terraform"
    "demo.hashicorp.com/cluster"   = var.cluster_name
    "demo.hashicorp.com/mode"      = var.integration_mode
  }
}

resource "kubernetes_namespace_v1" "vault_integration" {
  metadata {
    name   = var.namespace
    labels = local.labels
  }
}

resource "kubernetes_config_map_v1" "vault_connection" {
  metadata {
    name      = "vault-connection"
    namespace = kubernetes_namespace_v1.vault_integration.metadata[0].name
    labels    = local.labels
  }

  data = {
    address = var.vault_address
  }
}

resource "helm_release" "vault_secrets_operator" {
  name             = "vault-secrets-operator"
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "vault-secrets-operator"
  namespace        = kubernetes_namespace_v1.vault_integration.metadata[0].name
  create_namespace = false
  skip_crds        = false
  wait             = true
  timeout          = 600

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "helm_release" "secrets_store_csi_driver" {
  count = var.integration_mode == "vso_csi" ? 1 : 0

  name             = "secrets-store-csi-driver"
  repository       = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart            = "secrets-store-csi-driver"
  namespace        = "kube-system"
  create_namespace = false
  wait             = true
  timeout          = 600

  values = [yamlencode({
    syncSecret = {
      enabled = true
    }
    enableSecretRotation = true
  })]
}
