variable "cluster_endpoint" {
  description = "(Required) Kubernetes API server endpoint URL."
  type        = string

  validation {
    condition     = can(regex("^https://[^\\s]+$", var.cluster_endpoint))
    error_message = "The `cluster_endpoint` variable must be a valid HTTPS URL."
  }
}

variable "tfc_organization_name" {
  description = "(Required) Terraform Cloud organization name used for RBAC mapping."
  type        = string

  validation {
    condition     = trimspace(var.tfc_organization_name) != ""
    error_message = "The `tfc_organization_name` variable must not be empty."
  }
}
