output "argo_workflows" {
  description = "Map of attributes for the Argo Workflows Helm release."
  value       = module.eks_blueprints_addons.argo_workflows
}

output "aws_load_balancer_controller" {
  description = "Map of attributes for the AWS Load Balancer Controller Helm release and IRSA resources."
  value       = module.eks_blueprints_addons.aws_load_balancer_controller
}

output "eks_addons" {
  description = "Map of attributes for enabled EKS add-ons."
  value       = module.eks_blueprints_addons.eks_addons
}
