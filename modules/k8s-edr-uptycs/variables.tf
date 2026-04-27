variable "addons_dependency_token" {
  description = "(Required) Dependency token to ensure this component runs after EKS add-ons."
  type        = string
}

variable "cluster_name" {
  description = "(Required) EKS cluster name used for metadata labeling."
  type        = string
}

variable "cluster_readiness_token" {
  description = "(Required) Dependency token to ensure this component runs after cluster RBAC readiness."
  type        = string
}

variable "uptycs_tags" {
  description = "(Required) Comma-separated Uptycs tags in UPDATE/CCODE/UT/OWNER format."
  type        = string
}

variable "additional_values_yaml" {
  description = "(Optional) Additional Helm values YAML documents merged after default tag configuration."
  type        = list(string)
  default     = []
}

variable "helm_chart" {
  description = "(Optional) Uptycs Helm chart name."
  type        = string
  default     = "k8sosquery"
}

variable "helm_chart_version" {
  description = "(Optional) Uptycs Helm chart version. Leave empty to install the latest available chart."
  type        = string
  default     = ""
}

variable "helm_repository" {
  description = "(Optional) Uptycs Helm repository URL."
  type        = string
  default     = "https://uptycslabs.github.io/kspm-helm-charts"
}

variable "namespace" {
  description = "(Optional) Namespace where Uptycs EDR components are installed."
  type        = string
  default     = "uptycs"
}
