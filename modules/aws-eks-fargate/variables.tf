variable "kubernetes_version" {
  description = "(Required) Kubernetes version used by the EKS cluster."
  type        = string

  validation {
    condition     = can(regex("^1\\.[0-9]{1,2}$", var.kubernetes_version))
    error_message = "The `kubernetes_version` variable must follow a Kubernetes minor version format like \"1.30\"."
  }
}

variable "private_subnets" {
  description = "(Required) Private subnet identifiers used by the EKS cluster."
  type        = list(string)

  validation {
    condition     = length(var.private_subnets) > 0
    error_message = "The `private_subnets` variable must contain at least one subnet identifier."
  }
}

variable "tfc_kubernetes_audience" {
  description = "(Required) Audience used for Kubernetes OIDC authentication."
  type        = string

  validation {
    condition     = trimspace(var.tfc_kubernetes_audience) != ""
    error_message = "The `tfc_kubernetes_audience` variable must not be empty."
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

variable "cluster_name" {
  description = "(Optional) EKS cluster name."
  type        = string
  default     = "eks-cluster"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.cluster_name))
    error_message = "The `cluster_name` variable must contain only lowercase letters, numbers, and hyphens. The default is \"eks-cluster\"."
  }
}

variable "clusteradmin_role_name" {
  description = "(Optional) IAM role name for cluster admin access when role creation is enabled."
  type        = string
  default     = ""

  validation {
    condition     = var.clusteradmin_role_name == "" || can(regex("^[A-Za-z0-9+=,.@_-]{1,64}$", var.clusteradmin_role_name))
    error_message = "The `clusteradmin_role_name` variable must be empty or a valid IAM role name (1-64 characters)."
  }
}

variable "create_clusteradmin_role" {
  description = "(Optional) Whether to create a new IAM role for cluster admin access."
  type        = bool
  default     = false
}

variable "eks_clusteradmin_arn" {
  description = "(Optional) Existing IAM role or user ARN used for cluster admin access."
  type        = string
  default     = ""

  validation {
    condition     = var.eks_clusteradmin_arn == "" || can(regex("^arn:aws:iam::[0-9]{12}:(role|user)/.+$", var.eks_clusteradmin_arn))
    error_message = "The `eks_clusteradmin_arn` variable must be empty or a valid IAM role/user ARN."
  }
}

variable "eks_clusteradmin_username" {
  description = "(Optional) Username mapped to cluster admin access when using an existing IAM principal."
  type        = string
  default     = ""

  validation {
    condition     = var.eks_clusteradmin_username == "" || length(var.eks_clusteradmin_username) <= 128
    error_message = "The `eks_clusteradmin_username` variable must be empty or at most 128 characters long."
  }
}

variable "region" {
  description = "(Optional) AWS region used for helper output generation."
  type        = string
  default     = "ap-southeast-2"

  validation {
    condition     = can(regex("^[a-z]{2}(-gov)?-[a-z]+-[0-9]$", var.region))
    error_message = "The `region` variable must be a valid AWS region name. The default is \"ap-southeast-2\"."
  }
}

variable "role_arn" {
  description = "(Optional) IAM role ARN used by Terraform to administer EKS resources."
  type        = string
  default     = ""

  validation {
    condition     = var.role_arn == "" || can(regex("^arn:aws:iam::[0-9]{12}:role/.+$", var.role_arn))
    error_message = "The `role_arn` variable must be empty or a valid IAM role ARN."
  }
}

variable "tfc_hostname" {
  description = "(Optional) Terraform Cloud or Terraform Enterprise hostname."
  type        = string
  default     = "https://app.terraform.io"

  validation {
    condition     = can(regex("^https?://[^\\s]+$", var.tfc_hostname))
    error_message = "The `tfc_hostname` variable must be a valid HTTP or HTTPS URL. The default is \"https://app.terraform.io\"."
  }
}
