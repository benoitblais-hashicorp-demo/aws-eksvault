variable "app_namespace" {
  description = "(Required) Namespace where the demo application is deployed."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.app_namespace))
    error_message = "The `app_namespace` variable must be a valid Kubernetes namespace name."
  }
}

variable "demo_app_image" {
  description = "(Required) Container image for the demo web application."
  type        = string
}

variable "initial_image_url" {
  description = "(Optional) Initial image URL stored in Vault and rendered by the demo webpage."
  type        = string
  default     = "https://developer.hashicorp.com/favicon.ico"
}

variable "initial_message" {
  description = "(Optional) Initial message stored in Vault and rendered by the demo webpage."
  type        = string
  default     = "Secret synced from Vault through VSO."
}

variable "vault_address" {
  description = "(Required) Vault address used by the VaultConnection custom resource."
  type        = string
}

variable "vault_auth_path" {
  description = "(Required) Vault Kubernetes auth mount path used by VaultAuth."
  type        = string
}

variable "vault_auth_role" {
  description = "(Required) Vault role name used by VaultAuth."
  type        = string
}

variable "vault_kv_mount_path" {
  description = "(Required) Vault KVv2 mount path containing demo secrets."
  type        = string
}

variable "vault_secret_path_prefix" {
  description = "(Required) Vault KVv2 secret prefix used by this demo (cluster-scoped prefix recommended)."
  type        = string
}

variable "vso_service_account_name" {
  description = "(Optional) Service account used by VaultAuth in the demo namespace."
  type        = string
  default     = "vault-secrets-operator-controller-manager"
}
