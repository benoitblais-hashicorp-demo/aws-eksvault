variable "region" {
  description = "(Optional) AWS region where resources are deployed."
  type        = string
  default     = "ca-central-1"
}

variable "az_filter_instance_type" {
  description = "(Optional) EC2 instance type used to filter supported availability zones."
  type        = string
  default     = "m5.large"
}

variable "vpc_name" {
  description = "(Optional) Name of the VPC to be created."
  type        = string
  default     = "vpc-ca"
}

variable "vpc_cidr" {
  description = "(Optional) CIDR block for the VPC network."
  type        = string
  default     = "10.0.0.0/16"
}

variable "kubernetes_version" {
  description = "(Optional) Kubernetes version to use for the EKS clusters."
  type        = string
  default     = "1.35"
}

variable "cluster_name_vso" {
  description = "(Optional) Name of the EKS cluster dedicated to VSO demonstrations."
  type        = string
  default     = "eks-ca-vso"
}

variable "cluster_name_vso_csi" {
  description = "(Optional) Name of the EKS cluster dedicated to VSO with CSI demonstrations."
  type        = string
  default     = "eks-ca-csi"
}

variable "enable_vso_cluster" {
  description = "(Optional) Whether to deploy the VSO EKS cluster and its dependent components."
  type        = bool
  default     = true
}

variable "enable_vso_csi_cluster" {
  description = "(Optional) Whether to deploy the VSO+CSI EKS cluster and its dependent components."
  type        = bool
  default     = true
}

variable "clusteradmin_role_name" {
  description = "(Optional) Name for the IAM role to create for cluster admin access."
  type        = string
  default     = ""
}

variable "tfc_hostname" {
  description = "(Optional) Terraform Cloud or Terraform Enterprise hostname."
  type        = string
  default     = "https://app.terraform.io"
}

variable "tfc_kubernetes_audience" {
  description = "(Optional) Audience value used by OIDC RBAC mapping."
  type        = string
  default     = "k8s.workload.identity"
}

variable "tfc_organization_name" {
  description = "(Optional) Name of the Terraform Cloud organization used by RBAC."
  type        = string
  default     = "benoitblais-hashicorp"
}

variable "namespace_vso" {
  description = "(Optional) Namespace used in the VSO demo cluster."
  type        = string
  default     = "vault-secrets-operator"
}

variable "namespace_vso_csi" {
  description = "(Optional) Namespace used in the VSO+CSI demo cluster."
  type        = string
  default     = "vault-secrets-csi"
}

variable "edr_namespace" {
  description = "(Optional) Namespace where Uptycs EDR components are deployed."
  type        = string
  default     = "uptycs"
}

variable "edr_helm_repository" {
  description = "(Optional) Uptycs EDR Helm repository URL."
  type        = string
  default     = "https://uptycslabs.github.io/kspm-helm-charts"
}

variable "edr_helm_chart" {
  description = "(Optional) Uptycs EDR Helm chart name."
  type        = string
  default     = "k8sosquery"
}

variable "edr_helm_chart_version" {
  description = "(Optional) Uptycs EDR Helm chart version."
  type        = string
  default     = ""
}

variable "edr_k8sosquery_values_yaml" {
  description = "(Optional) Raw YAML values for Uptycs EDR chart."
  type        = string
  default     = ""
  sensitive   = true
}

variable "edr_uptycs_tags" {
  description = "(Optional) Uptycs tags for Kubernetes EDR in UPDATE/CCODE/UT/OWNER format."
  type        = string
  default     = "UPDATE/PROD,CCODE/HashiCorp,UT/20A7V,OWNER/security-team@ibm.com"
}

variable "vault_address" {
  description = "(Optional) Vault address. Leave empty to skip Vault components."
  type        = string
  default     = ""
}

variable "vault_namespace" {
  description = "(Optional) Vault namespace where resources are managed."
  type        = string
  default     = "admin"
}

variable "vault_kv_mount_path" {
  description = "(Optional) KVv2 mount path used for demo secrets."
  type        = string
  default     = "kvv2"
}

variable "vault_secret_path_prefix" {
  description = "(Optional) Secret path prefix under the KVv2 mount for demo reads."
  type        = string
  default     = "demo"
}

variable "vault_kubernetes_auth_path_vso" {
  description = "(Optional) Base Vault Kubernetes auth mount path used for the VSO cluster."
  type        = string
  default     = "kubernetes-vso"
}

variable "vault_kubernetes_auth_path_vso_csi" {
  description = "(Optional) Base Vault Kubernetes auth mount path used for the VSO+CSI cluster."
  type        = string
  default     = "kubernetes-vso-csi"
}

variable "vault_kubernetes_token_reviewer_jwt" {
  description = "(Optional) Token reviewer JWT used by Vault Kubernetes auth backends."
  type        = string
  default     = ""
  sensitive   = true
}

variable "vso_service_account_name" {
  description = "(Optional) Service account name bound to the Vault role for VSO."
  type        = string
  default     = "vault-secrets-operator-controller-manager"
}

variable "csi_service_account_name" {
  description = "(Optional) Service account name bound to the Vault role for CSI integration."
  type        = string
  default     = "vault-csi-provider"
}

variable "csi_service_account_namespace" {
  description = "(Optional) Namespace for the CSI provider service account bound to Vault auth."
  type        = string
  default     = "kube-system"
}

variable "demo_webapp_image" {
  description = "(Optional) Demo webapp image. Leave empty to skip demo deployment."
  type        = string
  default     = "ghcr.io/benoitblais-hashicorp-demo/demo-go-web:v1.1.0"
}
