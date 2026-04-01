locals {
  static_app_name       = "static-secrets"
  static_app_secret     = "kv-secrets"
  static_app_secret_key = "${var.vault_secret_path_prefix}/vso/webapp"
}

resource "vault_kv_secret_v2" "webapp" {
  mount               = var.vault_kv_mount_path
  name                = local.static_app_secret_key
  delete_all_versions = false

  data_json = jsonencode({
    message   = var.initial_message
    image_url = var.initial_image_url
  })

  lifecycle {
    # Allow updates in Vault UI for demo purposes without Terraform forcing rollback on next run.
    ignore_changes = [data_json]
  }
}

resource "kubernetes_manifest" "vault_connection" {
  manifest = {
    apiVersion = "secrets.hashicorp.com/v1beta1"
    kind       = "VaultConnection"
    metadata = {
      name      = "default"
      namespace = var.app_namespace
    }
    spec = {
      address = var.vault_address
    }
  }
}

resource "kubernetes_manifest" "vault_auth" {
  depends_on = [kubernetes_manifest.vault_connection]

  manifest = {
    apiVersion = "secrets.hashicorp.com/v1beta1"
    kind       = "VaultAuth"
    metadata = {
      name      = "default"
      namespace = var.app_namespace
    }
    spec = {
      method             = "kubernetes"
      mount              = var.vault_auth_path
      vaultConnectionRef = "default"
      kubernetes = {
        role           = var.vault_auth_role
        serviceAccount = var.vso_service_account_name
        audiences      = ["vault"]
      }
    }
  }
}

resource "kubernetes_manifest" "vault_static_secret" {
  depends_on = [
    kubernetes_manifest.vault_auth,
    vault_kv_secret_v2.webapp,
  ]

  manifest = {
    apiVersion = "secrets.hashicorp.com/v1beta1"
    kind       = "VaultStaticSecret"
    metadata = {
      name      = "vault-static-secret"
      namespace = var.app_namespace
    }
    spec = {
      type  = "kv-v2"
      mount = var.vault_kv_mount_path
      path  = local.static_app_secret_key
      destination = {
        name   = local.static_app_secret
        create = true
      }
      refreshAfter = "5s"
      vaultAuthRef = "default"
      rolloutRestartTargets = [
        {
          kind = "Deployment"
          name = local.static_app_name
        }
      ]
    }
  }
}

resource "kubernetes_deployment" "static_app" {
  depends_on = [kubernetes_manifest.vault_static_secret]

  metadata {
    name      = local.static_app_name
    namespace = var.app_namespace
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = local.static_app_name
      }
    }

    template {
      metadata {
        labels = {
          app = local.static_app_name
        }
      }

      spec {
        container {
          image = var.demo_app_image
          name  = local.static_app_name

          port {
            container_port = 8080
          }

          env {
            name  = "TITLE"
            value = "Vault Secrets Operator is amazing!"
          }

          env {
            name  = "SUB_TITLE"
            value = "Update the Vault secret and refresh this page to see live changes."
          }

          env {
            name  = "LEARN_LINK"
            value = "https://developer.hashicorp.com/vault/docs/platform/k8s/vso"
          }

          env {
            name = "FIRST_MESSAGE"
            value_from {
              secret_key_ref {
                name = local.static_app_secret
                key  = "message"
              }
            }
          }

          env {
            name = "IMAGE_URL"
            value_from {
              secret_key_ref {
                name = local.static_app_secret
                key  = "image_url"
              }
            }
          }

          resources {
            limits = {
              cpu    = "100m"
              memory = "128Mi"
            }

            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
  wait_for_rollout = false
}

resource "time_sleep" "wait_60_seconds" {
  depends_on = [kubernetes_deployment.static_app]

  create_duration = "60s"
  # allow for ingress controller to be ready
}

# static app ingress
resource "kubernetes_ingress_v1" "static_app" {
  depends_on             = [time_sleep.wait_60_seconds]
  wait_for_load_balancer = false
  metadata {
    name      = local.static_app_name
    namespace = var.app_namespace
    annotations = {
      "kubernetes.io/ingress.class"           = "alb"
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
    }
  }

  spec {
    ingress_class_name = "alb"

    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = local.static_app_name
              port {
                number = 8080
              }
            }
          }
        }
      }
    }
  }
}


# static app service
resource "kubernetes_service_v1" "static_app" {
  depends_on             = [time_sleep.wait_60_seconds]
  wait_for_load_balancer = false
  metadata {
    name      = local.static_app_name
    namespace = var.app_namespace
  }

  spec {
    selector = {
      app = local.static_app_name
    }

    port {
      protocol    = "TCP"
      port        = 8080
      target_port = 8080
    }

    type = "ClusterIP"
  }
}
