#AWS VPC
component "vpc" {
  for_each = var.regions

  source = "./modules/aws-vpc"

  inputs = {
    vpc_name = var.vpc_name
    vpc_cidr = var.vpc_cidr
  }

  providers = {
    aws     = provider.aws.configurations[each.value]
  }
} 

#AWS EKS - VSO lane
component "eks_vso" {
  for_each = var.regions

  source = "./modules/aws-eks-fargate"

  inputs = {
    vpc_id             = component.vpc[each.value].vpc_id
    private_subnets    = component.vpc[each.value].private_subnets
    kubernetes_version = var.kubernetes_version
    cluster_name       = var.cluster_name_vso
    tfc_hostname       = var.tfc_hostname
    tfc_kubernetes_audience = var.tfc_kubernetes_audience
    create_clusteradmin_role = var.create_clusteradmin_role
    clusteradmin_role_name   = var.clusteradmin_role_name
    eks_clusteradmin_arn     = var.eks_clusteradmin_arn
    eks_clusteradmin_username = var.eks_clusteradmin_username
  }

  providers = {
    aws        = provider.aws.configurations[each.value]
    cloudinit  = provider.cloudinit.this
    kubernetes = provider.kubernetes.this
    time       = provider.time.this
    tls        = provider.tls.this
  }
}

#AWS EKS - VSO with CSI lane
component "eks_vso_csi" {
  for_each = var.regions

  source = "./modules/aws-eks-fargate"

  inputs = {
    vpc_id               = component.vpc[each.value].vpc_id
    private_subnets      = component.vpc[each.value].private_subnets
    kubernetes_version   = var.kubernetes_version
    cluster_name         = var.cluster_name_vso_csi
    tfc_hostname         = var.tfc_hostname
    tfc_kubernetes_audience = var.tfc_kubernetes_audience
    create_clusteradmin_role = var.create_clusteradmin_role
    clusteradmin_role_name   = var.clusteradmin_role_name
    eks_clusteradmin_arn     = var.eks_clusteradmin_arn
    eks_clusteradmin_username = var.eks_clusteradmin_username
  }

  providers = {
    aws        = provider.aws.configurations[each.value]
    cloudinit  = provider.cloudinit.this
    kubernetes = provider.kubernetes.this
    time       = provider.time.this
    tls        = provider.tls.this
  }
}

# Update K8s role-binding - VSO lane
component "k8s-rbac-vso" {
  for_each = var.regions

  source = "./modules/k8s-rbac"

  inputs = {
    cluster_endpoint      = component.eks_vso[each.value].cluster_endpoint
    tfc_organization_name = var.tfc_organization_name
  }

  providers = {
    kubernetes = provider.kubernetes.vso_configurations[each.value]
    time       = provider.time.this
  }
}

# Update K8s role-binding - VSO with CSI lane
component "k8s-rbac-vso-csi" {
  for_each = var.regions

  source = "./modules/k8s-rbac"

  inputs = {
    cluster_endpoint      = component.eks_vso_csi[each.value].cluster_endpoint
    tfc_organization_name = var.tfc_organization_name
  }

  providers = {
    kubernetes = provider.kubernetes.vso_csi_configurations[each.value]
    time       = provider.time.this
  }
}


# K8s Addons - VSO lane
component "k8s-addons-vso" {
  for_each = var.regions

  source = "./modules/aws-eks-addon"

  inputs = {
    cluster_name                       = component.eks_vso[each.value].cluster_name
    vpc_id                             = component.vpc[each.value].vpc_id
    private_subnets                    = component.vpc[each.value].private_subnets
    cluster_endpoint                   = component.eks_vso[each.value].cluster_endpoint
    cluster_version                    = component.eks_vso[each.value].cluster_version
    oidc_provider_arn                  = component.eks_vso[each.value].oidc_provider_arn
    cluster_certificate_authority_data = component.eks_vso[each.value].cluster_certificate_authority_data
    oidc_binding_id                    = component.k8s-rbac-vso[each.value].oidc_binding_id
  }

  providers = {
    kubernetes = provider.kubernetes.vso_oidc_configurations[each.value]
    helm       = provider.helm.vso_oidc_configurations[each.value]
    aws        = provider.aws.configurations[each.value]
    time       = provider.time.this
  }
}

# K8s Addons - VSO with CSI lane
component "k8s-addons-vso-csi" {
  for_each = var.regions

  source = "./modules/aws-eks-addon"

  inputs = {
    cluster_name                       = component.eks_vso_csi[each.value].cluster_name
    vpc_id                             = component.vpc[each.value].vpc_id
    private_subnets                    = component.vpc[each.value].private_subnets
    cluster_endpoint                   = component.eks_vso_csi[each.value].cluster_endpoint
    cluster_version                    = component.eks_vso_csi[each.value].cluster_version
    oidc_provider_arn                  = component.eks_vso_csi[each.value].oidc_provider_arn
    cluster_certificate_authority_data = component.eks_vso_csi[each.value].cluster_certificate_authority_data
    oidc_binding_id                    = component.k8s-rbac-vso-csi[each.value].oidc_binding_id
  }

  providers = {
    kubernetes = provider.kubernetes.vso_csi_oidc_configurations[each.value]
    helm       = provider.helm.vso_csi_oidc_configurations[each.value]
    aws        = provider.aws.configurations[each.value]
    time       = provider.time.this
  }
}

# Namespace - VSO lane
component "k8s-namespace-vso" {
  for_each = var.regions

  source = "./modules/k8s-namespace"

  inputs = {
    namespace = var.namespace_vso
    labels = {
      addons-count = tostring(length(keys(component.k8s-addons-vso[each.value].eks_addons)))
    }
  }

  providers = {
    kubernetes = provider.kubernetes.vso_oidc_configurations[each.value]
  }
}

# Namespace - VSO with CSI lane
component "k8s-namespace-vso-csi" {
  for_each = var.regions

  source = "./modules/k8s-namespace"

  inputs = {
    namespace = var.namespace_vso_csi
    labels = {
      addons-count = tostring(length(keys(component.k8s-addons-vso-csi[each.value].eks_addons)))
    }
  }

  providers = {
    kubernetes = provider.kubernetes.vso_csi_oidc_configurations[each.value]
  }
}

# Optional Vault integration bootstrap - VSO lane
component "vault-integration-vso" {
  for_each = var.vault_address != "" ? var.regions : toset([])

  source = "./modules/vault-integration-bootstrap"

  inputs = {
    cluster_name      = component.eks_vso[each.value].cluster_name
    integration_mode  = "vso"
    namespace         = var.namespace_vso
    vault_address     = var.vault_address
  }

  providers = {
    kubernetes = provider.kubernetes.vso_oidc_configurations[each.value]
    helm       = provider.helm.vso_oidc_configurations[each.value]
  }
}

# Optional Vault integration bootstrap - VSO with CSI lane
component "vault-integration-vso-csi" {
  for_each = var.vault_address != "" ? var.regions : toset([])

  source = "./modules/vault-integration-bootstrap"

  inputs = {
    cluster_name     = component.eks_vso_csi[each.value].cluster_name
    integration_mode = "vso_csi"
    namespace        = var.namespace_vso_csi
    vault_address    = var.vault_address
  }

  providers = {
    kubernetes = provider.kubernetes.vso_csi_oidc_configurations[each.value]
    helm       = provider.helm.vso_csi_oidc_configurations[each.value]
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
  for_each = var.vault_address != "" ? var.regions : toset([])

  source = "./modules/vault-kubernetes-auth"

  inputs = {
    cluster_name                       = component.eks_vso[each.value].cluster_name
    cluster_endpoint                   = component.eks_vso[each.value].cluster_endpoint
    cluster_certificate_authority_data = component.eks_vso[each.value].cluster_certificate_authority_data
    token_reviewer_jwt                 = var.vault_kubernetes_token_reviewer_jwt != "" ? var.vault_kubernetes_token_reviewer_jwt : component.eks_vso[each.value].eks_token
    auth_path                          = "${var.vault_kubernetes_auth_path_vso}-${each.value}"
    kv_mount_path                      = var.vault_kv_mount_path
    secret_path_prefix                 = "${var.vault_secret_path_prefix}/${component.eks_vso[each.value].cluster_name}"
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
  for_each = var.vault_address != "" ? var.regions : toset([])

  source = "./modules/vault-kubernetes-auth"

  inputs = {
    cluster_name                       = component.eks_vso_csi[each.value].cluster_name
    cluster_endpoint                   = component.eks_vso_csi[each.value].cluster_endpoint
    cluster_certificate_authority_data = component.eks_vso_csi[each.value].cluster_certificate_authority_data
    token_reviewer_jwt                 = var.vault_kubernetes_token_reviewer_jwt != "" ? var.vault_kubernetes_token_reviewer_jwt : component.eks_vso_csi[each.value].eks_token
    auth_path                          = "${var.vault_kubernetes_auth_path_vso_csi}-${each.value}"
    kv_mount_path                      = var.vault_kv_mount_path
    secret_path_prefix                 = "${var.vault_secret_path_prefix}/${component.eks_vso_csi[each.value].cluster_name}"
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
