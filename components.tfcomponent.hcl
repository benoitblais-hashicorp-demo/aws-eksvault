#AWS VPC
component "vpc" {

  source = "./modules/aws-vpc"

  inputs = {
    vpc_name = var.vpc_name
    vpc_cidr = var.vpc_cidr
  }

  providers = {
    aws = provider.aws.configurations
  }

} 

#AWS EKS - VSO lane
component "eks_vso" {

  source = "./modules/aws-eks-fargate"

  inputs = {
    cluster_name              = var.cluster_name_vso
    vpc_id                    = component.vpc.vpc_id
    private_subnets           = component.vpc.private_subnets
    kubernetes_version        = var.kubernetes_version
    tfc_hostname              = var.tfc_hostname
    tfc_kubernetes_audience   = var.tfc_kubernetes_audience
    create_clusteradmin_role  = var.create_clusteradmin_role
    clusteradmin_role_name    = var.clusteradmin_role_name
    eks_clusteradmin_arn      = var.eks_clusteradmin_arn
    eks_clusteradmin_username = var.eks_clusteradmin_username
  }

  providers = {
    aws        = provider.aws.configurations
    cloudinit  = provider.cloudinit.this
    kubernetes = provider.kubernetes.this
    null       = provider.null.this
    time       = provider.time.this
    tls        = provider.tls.this
  }

}

#AWS EKS - VSO with CSI lane
component "eks_vso_csi" {

  source = "./modules/aws-eks-fargate"

  inputs = {
    cluster_name              = var.cluster_name_vso_csi
    vpc_id                    = component.vpc.vpc_id
    private_subnets           = component.vpc.private_subnets
    kubernetes_version        = var.kubernetes_version
    tfc_hostname              = var.tfc_hostname
    tfc_kubernetes_audience   = var.tfc_kubernetes_audience
    create_clusteradmin_role  = var.create_clusteradmin_role
    clusteradmin_role_name    = var.clusteradmin_role_name
    eks_clusteradmin_arn      = var.eks_clusteradmin_arn
    eks_clusteradmin_username = var.eks_clusteradmin_username
  }

  providers = {
    aws        = provider.aws.configurations
    cloudinit  = provider.cloudinit.this
    kubernetes = provider.kubernetes.this
    null       = provider.null.this
    time       = provider.time.this
    tls        = provider.tls.this
  }

}

# Update K8s role-binding - VSO lane
component "k8s-rbac-vso" {

  source = "./modules/k8s-rbac"

  inputs = {
    cluster_endpoint      = component.eks_vso.cluster_endpoint
    tfc_organization_name = var.tfc_organization_name
  }

  providers = {
    kubernetes = provider.kubernetes.vso_configurations
    time       = provider.time.this
  }

}

# Update K8s role-binding - VSO with CSI lane
component "k8s-rbac-vso-csi" {

  source = "./modules/k8s-rbac"

  inputs = {
    cluster_endpoint      = component.eks_vso_csi.cluster_endpoint
    tfc_organization_name = var.tfc_organization_name
  }

  providers = {
    kubernetes = provider.kubernetes.vso_csi_configurations
    time       = provider.time.this
  }

}

# K8s Addons - VSO lane
component "k8s-addons-vso" {

  source = "./modules/aws-eks-addon"

  inputs = {
    cluster_name                       = component.eks_vso.cluster_name
    vpc_id                             = component.vpc.vpc_id
    private_subnets                    = component.vpc.private_subnets
    cluster_endpoint                   = component.eks_vso.cluster_endpoint
    cluster_version                    = component.eks_vso.cluster_version
    oidc_provider_arn                  = component.eks_vso.oidc_provider_arn
    cluster_certificate_authority_data = component.eks_vso.cluster_certificate_authority_data
    oidc_binding_id                    = component.k8s-rbac-vso.oidc_binding_id
  }

  providers = {
    kubernetes = provider.kubernetes.vso_oidc_configurations
    helm       = provider.helm.vso_oidc_configurations
    aws        = provider.aws.configurations
    time       = provider.time.this
    random     = provider.random.this
  }

}

# K8s Addons - VSO with CSI lane
component "k8s-addons-vso-csi" {

  source = "./modules/aws-eks-addon"

  inputs = {
    cluster_name                       = component.eks_vso_csi.cluster_name
    vpc_id                             = component.vpc.vpc_id
    private_subnets                    = component.vpc.private_subnets
    cluster_endpoint                   = component.eks_vso_csi.cluster_endpoint
    cluster_version                    = component.eks_vso_csi.cluster_version
    oidc_provider_arn                  = component.eks_vso_csi.oidc_provider_arn
    cluster_certificate_authority_data = component.eks_vso_csi.cluster_certificate_authority_data
    oidc_binding_id                    = component.k8s-rbac-vso-csi.oidc_binding_id
  }

  providers = {
    kubernetes = provider.kubernetes.vso_csi_oidc_configurations
    helm       = provider.helm.vso_csi_oidc_configurations
    aws        = provider.aws.configurations
    time       = provider.time.this
    random     = provider.random.this
  }

}

# Uptycs EDR - VSO lane
component "k8s-edr-vso" {

  source = "./modules/k8s-edr-uptycs"

  inputs = {
    cluster_name            = component.eks_vso.cluster_name
    namespace               = var.edr_namespace
    helm_repository         = var.edr_helm_repository
    helm_chart              = var.edr_helm_chart
    helm_chart_version      = var.edr_helm_chart_version
    additional_values_yaml  = var.edr_k8sosquery_values_yaml != "" ? [var.edr_k8sosquery_values_yaml] : []
    uptycs_tags             = var.edr_uptycs_tags
    cluster_readiness_token = component.k8s-rbac-vso.oidc_binding_id
    addons_dependency_token = tostring(length(keys(component.k8s-addons-vso.eks_addons)))
  }

  providers = {
    kubernetes = provider.kubernetes.vso_oidc_configurations
    helm       = provider.helm.vso_oidc_configurations
  }

}

# Uptycs EDR - VSO with CSI lane
component "k8s-edr-vso-csi" {

  source = "./modules/k8s-edr-uptycs"

  inputs = {
    cluster_name            = component.eks_vso_csi.cluster_name
    namespace               = var.edr_namespace
    helm_repository         = var.edr_helm_repository
    helm_chart              = var.edr_helm_chart
    helm_chart_version      = var.edr_helm_chart_version
    additional_values_yaml  = var.edr_k8sosquery_values_yaml != "" ? [var.edr_k8sosquery_values_yaml] : []
    uptycs_tags             = var.edr_uptycs_tags
    cluster_readiness_token = component.k8s-rbac-vso-csi.oidc_binding_id
    addons_dependency_token = tostring(length(keys(component.k8s-addons-vso-csi.eks_addons)))
  }

  providers = {
    kubernetes = provider.kubernetes.vso_csi_oidc_configurations
    helm       = provider.helm.vso_csi_oidc_configurations
  }

}

# Namespace - VSO lane
component "k8s-namespace-vso" {

  source = "./modules/k8s-namespace"

  inputs = {
    namespace = var.namespace_vso
    labels = {
      addons-count = tostring(length(keys(component.k8s-addons-vso.eks_addons)))
    }
  }

  providers = {
    kubernetes = provider.kubernetes.vso_oidc_configurations
  }

}

# Namespace - VSO with CSI lane
component "k8s-namespace-vso-csi" {

  source = "./modules/k8s-namespace"

  inputs = {
    namespace = var.namespace_vso_csi
    labels = {
      addons-count = tostring(length(keys(component.k8s-addons-vso-csi.eks_addons)))
    }
  }

  providers = {
    kubernetes = provider.kubernetes.vso_csi_oidc_configurations
  }

}

# Optional Vault integration bootstrap - VSO lane
component "vault-integration-vso" {
  for_each = var.vault_address != "" ? toset(["enabled"]) : toset([])

  source = "./modules/vault-integration-bootstrap"

  inputs = {
    cluster_name            = component.eks_vso.cluster_name
    integration_mode        = "vso"
    namespace               = var.namespace_vso
    vault_address           = var.vault_address
    cluster_readiness_token = component.k8s-rbac-vso.oidc_binding_id
  }

  providers = {
    kubernetes = provider.kubernetes.vso_oidc_configurations
    helm       = provider.helm.vso_oidc_configurations
  }

}

# Optional Vault integration bootstrap - VSO with CSI lane
component "vault-integration-vso-csi" {
  for_each = var.vault_address != "" ? toset(["enabled"]) : toset([])

  source = "./modules/vault-integration-bootstrap"

  inputs = {
    cluster_name            = component.eks_vso_csi.cluster_name
    integration_mode        = "vso_csi"
    namespace               = var.namespace_vso_csi
    vault_address           = var.vault_address
    cluster_readiness_token = component.k8s-rbac-vso-csi.oidc_binding_id
  }

  providers = {
    kubernetes = provider.kubernetes.vso_csi_oidc_configurations
    helm       = provider.helm.vso_csi_oidc_configurations
  }

}

# Optional one-time Vault KVv2 mount configuration
component "vault-kv-mount" {
  for_each = var.vault_address != "" ? toset(["once"]) : toset([])

  source = "./modules/vault-kv-mount"

  inputs = {
    mount_path = var.vault_kv_mount_path
  }

  providers = {
    vault = provider.vault.this
  }

}

# Optional Vault auth and policy configuration - VSO lane
component "vault-config-vso" {
  for_each = var.vault_address != "" ? toset(["enabled"]) : toset([])

  source = "./modules/vault-kubernetes-auth"

  inputs = {
    cluster_name                       = component.eks_vso.cluster_name
    cluster_endpoint                   = component.eks_vso.cluster_endpoint
    cluster_certificate_authority_data = component.eks_vso.cluster_certificate_authority_data
    token_reviewer_jwt                 = var.vault_kubernetes_token_reviewer_jwt != "" ? var.vault_kubernetes_token_reviewer_jwt : component.eks_vso.eks_token
    auth_path                          = "${var.vault_kubernetes_auth_path_vso}-${each.value}"
    kv_mount_path                      = var.vault_kv_mount_path
    secret_path_prefix                 = "${var.vault_secret_path_prefix}/${component.eks_vso.cluster_name}"
    vso_namespace                      = var.namespace_vso
    vso_service_account_name           = var.vso_service_account_name
    enable_csi_role                    = false
  }

  providers = {
    vault = provider.vault.this
  }

}

# Optional Vault auth and policy configuration - VSO with CSI lane
component "vault-config-vso-csi" {
  for_each = var.vault_address != "" ? toset(["enabled"]) : toset([])

  source = "./modules/vault-kubernetes-auth"

  inputs = {
    cluster_name                       = component.eks_vso_csi.cluster_name
    cluster_endpoint                   = component.eks_vso_csi.cluster_endpoint
    cluster_certificate_authority_data = component.eks_vso_csi.cluster_certificate_authority_data
    token_reviewer_jwt                 = var.vault_kubernetes_token_reviewer_jwt != "" ? var.vault_kubernetes_token_reviewer_jwt : component.eks_vso_csi.eks_token
    auth_path                          = "${var.vault_kubernetes_auth_path_vso_csi}-${each.value}"
    kv_mount_path                      = var.vault_kv_mount_path
    secret_path_prefix                 = "${var.vault_secret_path_prefix}/${component.eks_vso_csi.cluster_name}"
    vso_namespace                      = var.namespace_vso_csi
    vso_service_account_name           = var.vso_service_account_name
    enable_csi_role                    = true
    csi_service_account_name           = var.csi_service_account_name
    csi_service_account_namespace      = var.csi_service_account_namespace
  }

  providers = {
    vault = provider.vault.this
  }

}

# App Namespace - VSO lane
component "k8s-namespace-app-vso" {
  
  source = "./modules/k8s-namespace"

  inputs = {
    # You can add a var.app_namespace to variables.tfcomponent.hcl
    namespace = "demo-app" 
    labels = {
      addons-count = tostring(length(keys(component.k8s-addons-vso.eks_addons)))
    }
  }

  providers = {
    kubernetes = provider.kubernetes.vso_oidc_configurations
  }

}

# App Namespace - VSO with CSI lane
component "k8s-namespace-app-vso-csi" {
  
  source = "./modules/k8s-namespace"

  inputs = {
    # You can add a var.app_namespace to variables.tfcomponent.hcl
    namespace = "demo-app"
    labels = {
      addons-count = tostring(length(keys(component.k8s-addons-vso-csi.eks_addons)))
    }
  }

  providers = {
    kubernetes = provider.kubernetes.vso_csi_oidc_configurations
  }

}

# # Optional VSO static-secret demo webpage - VSO lane
# component "k8s-demo-app-vso" {
#   for_each = var.vault_address != "" && var.demo_webapp_image != "" ? toset(["enabled"]) : toset([])

#   source = "./modules/k8s-demo-app"

#   inputs = {
#     app_namespace                = component.k8s-namespace-app-vso.namespace
#     integration_dependency_token = component.vault-integration-vso.vso_release_revision
#     demo_app_image         = var.demo_webapp_image
#     vault_address          = var.vault_address
#     vault_auth_path        = component.vault-config-vso.auth_path
#     vault_auth_role        = component.vault-config-vso.vso_role_name
#     vault_kv_mount_path    = var.vault_kv_mount_path
#     vault_secret_path_prefix = "${var.vault_secret_path_prefix}/${component.eks_vso.cluster_name}"
#     vso_service_account_name = var.vso_service_account_name
#   }

#   providers = {
#     helm       = provider.helm.vso_oidc_configurations
#     kubernetes = provider.kubernetes.vso_oidc_configurations
#     time       = provider.time.this
#     vault      = provider.vault.this
#   }
# }

# # Optional VSO static-secret demo webpage - VSO with CSI lane
# component "k8s-demo-app-vso-csi" {
#   for_each = var.vault_address != "" && var.demo_webapp_image != "" ? toset(["enabled"]) : toset([])

#   source = "./modules/k8s-demo-app"

#   inputs = {
#     app_namespace = component.k8s-namespace-app-vso-csi.namespace
#     integration_dependency_token = component.vault-integration-vso-csi.vso_release_revision
#     demo_app_image           = var.demo_webapp_image
#     vault_address            = var.vault_address
#     vault_auth_path          = component.vault-config-vso-csi.auth_path
#     vault_auth_role          = component.vault-config-vso-csi.vso_role_name
#     vault_kv_mount_path      = var.vault_kv_mount_path
#     vault_secret_path_prefix = "${var.vault_secret_path_prefix}/${component.eks_vso_csi.cluster_name}"
#     vso_service_account_name = var.vso_service_account_name
#   }

#   providers = {
#     helm       = provider.helm.vso_csi_oidc_configurations
#     kubernetes = provider.kubernetes.vso_csi_oidc_configurations
#     time       = provider.time.this
#     vault      = provider.vault.this
#   }
# }
