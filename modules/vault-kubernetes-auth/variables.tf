variable "auth_path" {
  description = "(Required) Vault auth mount path for the Kubernetes auth backend."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-_/]*$", var.auth_path))
    error_message = "The `auth_path` variable must contain only lowercase letters, numbers, dash, underscore, and slash."
  }
}

variable "cluster_certificate_authority_data" {
  description = "(Required) Base64-encoded Kubernetes cluster CA certificate."
  type        = string

  validation {
    condition     = trimspace(var.cluster_certificate_authority_data) != ""
    error_message = "The `cluster_certificate_authority_data` variable must not be empty."
  }
}

variable "cluster_endpoint" {
  description = "(Required) Kubernetes API endpoint URL used by Vault token review."
  type        = string

  validation {
    condition     = can(regex("^https://[^\\s]+$", var.cluster_endpoint))
    error_message = "The `cluster_endpoint` variable must be a valid HTTPS URL."
  }
}

variable "cluster_name" {
  description = "(Required) Cluster name used for policy naming."
  type        = string

  validation {
    condition     = trimspace(var.cluster_name) != ""
    error_message = "The `cluster_name` variable must not be empty."
  }
}

variable "token_reviewer_jwt" {
  description = "(Required) JWT token used by Vault to call Kubernetes TokenReview API."
  type        = string
  sensitive   = true

  validation {
    condition     = trimspace(var.token_reviewer_jwt) != ""
    error_message = "The `token_reviewer_jwt` variable must not be empty."
  }
}

variable "vso_namespace" {
  description = "(Required) Namespace containing Vault Secrets Operator workloads."
  type        = string
}

variable "vso_service_account_name" {
  description = "(Required) Service account name bound to the VSO Vault role."
  type        = string
}

variable "csi_role_name" {
  description = "(Optional) Vault Kubernetes auth role name for CSI workloads."
  type        = string
  default     = "vso-csi-role"
}

variable "csi_service_account_name" {
  description = "(Optional) Service account name bound to the CSI Vault role."
  type        = string
  default     = "vault-csi-provider"
}

variable "csi_service_account_namespace" {
  description = "(Optional) Namespace of the CSI service account bound to the CSI Vault role."
  type        = string
  default     = "kube-system"
}

variable "enable_csi_role" {
  description = "(Optional) Whether to create a dedicated Vault Kubernetes auth role for CSI."
  type        = bool
  default     = false
}

variable "kv_mount_path" {
  description = "(Optional) KVv2 mount path containing demonstration secrets."
  type        = string
  default     = "kvv2"
}

variable "secret_path_prefix" {
  description = "(Optional) Secret path prefix under KVv2 for role policies."
  type        = string
  default     = "demo"
}

variable "token_max_ttl" {
  description = "(Optional) Maximum token TTL in seconds for Kubernetes auth roles."
  type        = number
  default     = 3600
}

variable "token_ttl" {
  description = "(Optional) Default token TTL in seconds for Kubernetes auth roles."
  type        = number
  default     = 1200
}

variable "vso_role_name" {
  description = "(Optional) Vault Kubernetes auth role name for VSO workloads."
  type        = string
  default     = "vso-role"
}
