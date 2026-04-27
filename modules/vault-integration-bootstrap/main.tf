locals {
  labels = {
    "app.kubernetes.io/managed-by" = "terraform"
    "demo.hashicorp.com/cluster"   = var.cluster_name
    "demo.hashicorp.com/mode"      = var.integration_mode
  }
}

resource "kubernetes_config_map_v1" "vault_connection" {
  metadata {
    name      = "vault-connection"
    namespace = var.namespace
    labels    = local.labels
  }

  data = {
    address = var.vault_address
  }
}

resource "kubernetes_service_account_v1" "cleanup" {
  metadata {
    name      = "pdcc-cleanup"
    namespace = var.namespace
    labels    = local.labels
  }
}

resource "kubernetes_role_binding_v1" "cleanup" {
  metadata {
    name      = "pdcc-cleanup"
    namespace = var.namespace
    labels    = local.labels
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.cleanup.metadata[0].name
    namespace = var.namespace
  }
}

resource "kubernetes_job_v1" "cleanup" {
  metadata {
    name      = "pdcc-cleanup"
    namespace = var.namespace
    labels    = local.labels
  }
  spec {
    template {
      metadata {
        labels = local.labels
      }
      spec {
        service_account_name = kubernetes_service_account_v1.cleanup.metadata[0].name
        container {
          name    = "kubectl"
          image   = "bitnami/kubectl:latest"
          command = ["kubectl", "delete", "job", "pdcc-vault-secrets-operator", "--namespace", var.namespace, "--ignore-not-found"]
        }
        restart_policy = "Never"
      }
    }
    backoff_limit = 1
  }
  wait_for_completion = true
}

resource "helm_release" "vault_secrets_operator" {
  name             = "vault-secrets-operator"
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "vault-secrets-operator"
  namespace        = var.namespace
  create_namespace = false
  skip_crds        = false
  wait             = true
  timeout          = 600

  depends_on = [kubernetes_job_v1.cleanup]

  values = [yamlencode({
    installCRDs = true
  })]
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
