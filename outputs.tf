output "cluster_name_vso" {
  description = "VSO EKS cluster name."
  value       = length(module.eks_vso) > 0 ? module.eks_vso[0].cluster_name : null
}

output "cluster_name_vso_csi" {
  description = "VSO+CSI EKS cluster name."
  value       = length(module.eks_vso_csi) > 0 ? module.eks_vso_csi[0].cluster_name : null
}

output "configure_kubectl_vso" {
  description = "Command to update kubeconfig for the VSO EKS cluster."
  value       = length(module.eks_vso) > 0 ? "aws eks --region ${var.region} update-kubeconfig --name ${module.eks_vso[0].cluster_name}" : null
}

output "configure_kubectl_vso_csi" {
  description = "Command to update kubeconfig for the VSO+CSI EKS cluster."
  value       = length(module.eks_vso_csi) > 0 ? "aws eks --region ${var.region} update-kubeconfig --name ${module.eks_vso_csi[0].cluster_name}" : null
}

output "vpc_id" {
  description = "VPC identifier."
  value       = module.vpc.vpc_id
}

output "vault_auth_path_vso" {
  description = "Vault auth path for VSO cluster."
  value       = length(module.vault_config_vso) > 0 ? module.vault_config_vso[0].auth_path : null
}

output "vault_auth_path_vso_csi" {
  description = "Vault auth path for VSO+CSI cluster."
  value       = length(module.vault_config_vso_csi) > 0 ? module.vault_config_vso_csi[0].auth_path : null
}

output "demo_webapp_url_vso" {
  description = "Demo webapp URL in VSO lane."
  value       = length(module.k8s_demo_app_vso) > 0 ? module.k8s_demo_app_vso[0].website_url : null
}

output "demo_webapp_url_vso_csi" {
  description = "Demo webapp URL in VSO+CSI lane."
  value       = length(module.k8s_demo_app_vso_csi) > 0 ? module.k8s_demo_app_vso_csi[0].website_url : null
}

output "container_image_used" {
  description = "Container image deployed by the demo webapp modules."
  value       = var.demo_webapp_image
}
