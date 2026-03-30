
variable "cluster_certificate_authority_data" {
  description = "(Required) Base64-encoded cluster certificate authority data."
  type        = string

  validation {
    condition     = trimspace(var.cluster_certificate_authority_data) != ""
    error_message = "The `cluster_certificate_authority_data` variable must not be empty."
  }
}

variable "cluster_endpoint" {
  description = "(Required) Kubernetes API server endpoint URL."
  type        = string

  validation {
    condition     = can(regex("^https://[^\\s]+$", var.cluster_endpoint))
    error_message = "The `cluster_endpoint` variable must be a valid HTTPS URL."
  }
}

variable "cluster_name" {
  description = "(Required) EKS cluster name."
  type        = string

  validation {
    condition     = trimspace(var.cluster_name) != ""
    error_message = "The `cluster_name` variable must not be empty."
  }
}

variable "cluster_version" {
  description = "(Required) Kubernetes version used by the EKS cluster."
  type        = string

  validation {
    condition     = can(regex("^1\\.[0-9]{1,2}$", var.cluster_version))
    error_message = "The `cluster_version` variable must follow a Kubernetes minor version format like \"1.30\"."
  }
}

variable "oidc_binding_id" {
  description = "(Required) OIDC binding identifier used for component dependency ordering."
  type        = string

  validation {
    condition     = trimspace(var.oidc_binding_id) != ""
    error_message = "The `oidc_binding_id` variable must not be empty."
  }
}

variable "oidc_provider_arn" {
  description = "(Required) OIDC provider ARN associated with the EKS cluster."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:oidc-provider/.+$", var.oidc_provider_arn))
    error_message = "The `oidc_provider_arn` variable must be a valid IAM OIDC provider ARN."
  }
}

variable "vpc_id" {
  description = "(Required) VPC identifier where EKS resources are deployed."
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-z0-9]+$", var.vpc_id))
    error_message = "The `vpc_id` variable must be a valid VPC identifier."
  }
}
