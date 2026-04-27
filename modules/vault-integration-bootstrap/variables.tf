variable "cluster_name" {
  description = "(Required) Cluster name used for tagging and release naming."
  type        = string

  validation {
    condition     = trimspace(var.cluster_name) != ""
    error_message = "The `cluster_name` variable must not be empty."
  }
}

variable "integration_mode" {
  description = "(Required) Integration profile."
  type        = string

  validation {
    condition     = contains(["vso", "vso_csi"], var.integration_mode)
    error_message = "The `integration_mode` variable must be one of \"vso\" or \"vso_csi\"."
  }
}

variable "namespace" {
  description = "(Required) Namespace where the integration components are installed."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.namespace))
    error_message = "The `namespace` variable must be a valid Kubernetes namespace name."
  }
}

variable "vault_address" {
  description = "(Required) Vault address used by downstream configuration."
  type        = string

  validation {
    condition     = can(regex("^https?://[^\\s]+$", var.vault_address))
    error_message = "The `vault_address` variable must be a valid HTTP or HTTPS URL."
  }
}

# tflint-ignore: terraform_unused_declarations
variable "cluster_readiness_token" {
  description = "(Optional) A dummy token used to explicitly order component execution (e.g. forcing wait for RBAC)."
  type        = string
  default     = ""
}
