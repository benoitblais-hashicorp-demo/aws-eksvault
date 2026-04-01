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

variable "clusteradmin_role_name" {
  description = "(Optional) Name for the IAM role to create for cluster admin access. Only used if create_clusteradmin_role is true. Defaults to '<cluster_name>-clusteradmin' if not specified."
  type        = string
  default     = ""
}

variable "create_clusteradmin_role" {
  description = "(Optional) Whether to create a new IAM role for EKS cluster admin access. If true, a role will be created. If false, you must provide eks_clusteradmin_arn and eks_clusteradmin_username."
  type        = bool
  default     = false
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
  description = "(Optional) Container image used by the VSO static-secret demo web application. Set to an empty string to skip provisioning the demo pod."
  type        = string
  default     = "ghcr.io/benoitblais-hashicorp-demo/demo-go-web:v1.1.0"
}

variable "edr_helm_chart" {
  description = "(Optional) Uptycs EDR Helm chart name for Kubernetes installation."
  type        = string
  default     = "k8sosquery"
}

variable "edr_helm_chart_version" {
  description = "(Optional) Uptycs EDR Helm chart version. Leave empty to use the latest available chart."
  type        = string
  default     = ""
}

variable "edr_helm_repository" {
  description = "(Optional) Uptycs EDR Helm repository URL for Kubernetes installation."
  type        = string
  default     = "https://uptycslabs.github.io/kspm-helm-charts"
}

variable "edr_k8sosquery_values_yaml" {
  description = "(Optional) Raw YAML content of the downloaded k8sosquery values file. Keep empty to use only module defaults."
  type        = string
  default     = ""
  sensitive   = true
}

variable "edr_namespace" {
  description = "(Optional) Namespace where Uptycs EDR components are deployed."
  type        = string
  default     = "uptycs"
}

variable "edr_uptycs_tags" {
  description = "(Optional) Uptycs tags for Kubernetes EDR in UPDATE/CCODE/UT/OWNER format."
  type        = string
  default     = "UPDATE/PROD,CCODE/HashiCorp,UT/20A7V,OWNER/security-team@ibm.com"
}

variable "eks_clusteradmin_arn" {
  description = "(Optional) ARN of an existing IAM role or user to grant cluster admin access. Only used if create_clusteradmin_role is false. Leave empty to skip additional admin access."
  type        = string
  default     = ""
}

variable "eks_clusteradmin_username" {
  description = "(Optional) Username to assign to the existing IAM principal for cluster admin access. Only used if create_clusteradmin_role is false and eks_clusteradmin_arn is provided."
  type        = string
  default     = ""
}

variable "kubernetes_version" {
  description = "(Optional) Kubernetes version to use for the EKS cluster."
  type        = string
  default     = "1.35"
}

variable "namespace" {
  description = "(Optional) Kubernetes namespace for application deployment."
  type        = string
  default     = "app"
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

variable "regions" {
  description = "(Optional) Set of AWS regions where resources will be deployed."
  type        = set(string)
  default     = ["ca-central-1"]
}

variable "role_arn" {
  description = "(Optional) ARN of the IAM role to assume for AWS operations."
  type        = string
  default     = "arn:aws:iam::353671346900:role/tfc-benoitblais-hashicorp"
}

variable "tfc_hostname" {
  description = "(Optional) Hostname of the Terraform Cloud or Terraform Enterprise instance."
  type        = string
  default     = "https://app.terraform.io"
}

variable "tfc_kubernetes_audience" {
  description = "(Optional) Audience value for Terraform Cloud workload identity federation with Kubernetes."
  type        = string
  default     = "k8s.workload.identity"
}

variable "tfc_organization_name" {
  description = "(Optional) Name of the Terraform Cloud organization."
  type        = string
  default     = "benoitblais-hashicorp"
}

variable "vault_address" {
  description = "(Optional) Vault address. When set, downstream components can enable Vault integrations."
  type        = string
  default     = ""
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
  description = "(Optional) Token reviewer JWT used by Vault Kubernetes auth backends. When empty, each EKS token is used."
  type        = string
  default     = ""
  sensitive   = true
}

variable "vault_kv_mount_path" {
  description = "(Optional) KVv2 mount path used for demo secrets."
  type        = string
  default     = "kvv2"
}

variable "vault_namespace" {
  description = "(Optional) Vault namespace where Kubernetes auth and policies are configured."
  type        = string
  default     = "admin"
}

variable "vault_secret_path_prefix" {
  description = "(Optional) Secret path prefix under the KVv2 mount for demo reads."
  type        = string
  default     = "demo"
}

variable "vpc_cidr" {
  description = "(Optional) CIDR block for the VPC network."
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "(Optional) Name of the VPC to be created."
  type        = string
  default     = "vpc-ca"
}

variable "vso_service_account_name" {
  description = "(Optional) Service account name bound to the Vault role for VSO."
  type        = string
  default     = "vault-secrets-operator-controller-manager"
}

variable "aws_identity_token" {
  description = "(Not Required) Ephemeral AWS identity token managed by the stack deployment identity_token wiring."
  type        = string
  ephemeral   = true
  sensitive   = true
}

variable "k8s_identity_token" {
  description = "(Not Required) Ephemeral Kubernetes identity token managed by the stack deployment identity_token wiring."
  type        = string
  ephemeral   = true
  sensitive   = true
}
