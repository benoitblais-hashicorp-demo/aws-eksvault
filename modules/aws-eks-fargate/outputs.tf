output "cluster_certificate_authority_data" {
  description = "Base64-encoded certificate authority data for the EKS cluster."
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_endpoint" {
  description = "Endpoint URL for the EKS cluster API server."
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "Name of the EKS cluster."
  value       = module.eks.cluster_name
}

output "cluster_version" {
  description = "Kubernetes version of the EKS cluster."
  value       = module.eks.cluster_version
}

output "clusteradmin_role_arn" {
  description = "ARN of the cluster admin IAM role when created."
  value       = var.create_clusteradmin_role ? aws_iam_role.eks_clusteradmin[0].arn : null
}

output "clusteradmin_role_name" {
  description = "Name of the cluster admin IAM role when created or provided."
  value       = var.create_clusteradmin_role ? aws_iam_role.eks_clusteradmin[0].name : var.eks_clusteradmin_username
}

output "configure_kubectl" {
  description = "Command to update kubeconfig for the EKS cluster."
  value       = "aws eks --region ${var.region} update-kubeconfig --name ${module.eks.cluster_name}"
}

output "eks_token" {
  description = "Authentication token for connecting to the EKS cluster."
  value       = data.aws_eks_cluster_auth.upstream_auth.token
  sensitive   = true
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN associated with the EKS cluster."
  value       = module.eks.oidc_provider_arn
}