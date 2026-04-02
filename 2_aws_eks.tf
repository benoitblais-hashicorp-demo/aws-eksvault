data "aws_caller_identity" "current" {}

locals {
  clusteradmin_role_name_vso     = var.clusteradmin_role_name != "" ? var.clusteradmin_role_name : "${var.cluster_name_vso}-clusteradmin"
  clusteradmin_role_name_vso_csi = var.clusteradmin_role_name != "" ? var.clusteradmin_role_name : "${var.cluster_name_vso_csi}-clusteradmin"

  eks_vso_access_entries = {
    admin = {
      kubernetes_groups = []
      principal_arn     = aws_iam_role.eks_clusteradmin_vso[0].arn

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  eks_vso_csi_access_entries = {
    admin = {
      kubernetes_groups = []
      principal_arn     = aws_iam_role.eks_clusteradmin_vso_csi[0].arn

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
}

resource "aws_iam_role" "eks_clusteradmin_vso" {
  count = var.enable_vso_cluster ? 1 : 0

  name = local.clusteradmin_role_name_vso

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Blueprint = var.cluster_name_vso
  }
}

resource "aws_iam_role" "eks_clusteradmin_vso_csi" {
  count = var.enable_vso_csi_cluster ? 1 : 0

  name = local.clusteradmin_role_name_vso_csi

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Blueprint = var.cluster_name_vso_csi
  }
}

module "eks_vso" {
  count = var.enable_vso_cluster ? 1 : 0

  source  = "terraform-aws-modules/eks/aws"
  version = "20.2.0"

  cluster_name                   = var.cluster_name_vso
  cluster_version                = var.kubernetes_version
  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  create_cluster_security_group = false
  create_node_security_group    = false

  cluster_enabled_log_types = []

  fargate_profiles = {
    app_wildcard = {
      selectors = [
        { namespace = "app*" },
        { namespace = "product*" },
        { namespace = "consul*" },
        { namespace = "frontend*" },
        { namespace = "payments*" }
      ]
      timeouts = {
        create = "30m"
        update = "30m"
        delete = "30m"
      }
    }
    kube_system = {
      name = "kube-system"
      selectors = [
        { namespace = "kube-system" }
      ]
      timeouts = {
        create = "30m"
        update = "30m"
        delete = "30m"
      }
    }
  }

  fargate_profile_defaults = {
    timeouts = {
      create = "30m"
      update = "30m"
      delete = "30m"
    }
  }

  enable_cluster_creator_admin_permissions = true
  access_entries                           = local.eks_vso_access_entries

  tags = {
    Blueprint = var.cluster_name_vso
  }
}

module "eks_vso_csi" {
  count = var.enable_vso_csi_cluster ? 1 : 0

  source  = "terraform-aws-modules/eks/aws"
  version = "20.2.0"

  cluster_name                   = var.cluster_name_vso_csi
  cluster_version                = var.kubernetes_version
  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  create_cluster_security_group = false
  create_node_security_group    = false

  cluster_enabled_log_types = []

  fargate_profiles = {
    app_wildcard = {
      selectors = [
        { namespace = "app*" },
        { namespace = "product*" },
        { namespace = "consul*" },
        { namespace = "frontend*" },
        { namespace = "payments*" }
      ]
      timeouts = {
        create = "30m"
        update = "30m"
        delete = "30m"
      }
    }
    kube_system = {
      name = "kube-system"
      selectors = [
        { namespace = "kube-system" }
      ]
      timeouts = {
        create = "30m"
        update = "30m"
        delete = "30m"
      }
    }
  }

  fargate_profile_defaults = {
    timeouts = {
      create = "30m"
      update = "30m"
      delete = "30m"
    }
  }

  enable_cluster_creator_admin_permissions = true
  access_entries                           = local.eks_vso_csi_access_entries

  tags = {
    Blueprint = var.cluster_name_vso_csi
  }
}

resource "aws_eks_identity_provider_config" "oidc_config_vso" {
  count = var.enable_vso_cluster ? 1 : 0

  cluster_name = module.eks_vso[0].cluster_name

  oidc {
    identity_provider_config_name = "tfstack-terraform-cloud"
    client_id                     = var.tfc_kubernetes_audience
    issuer_url                    = var.tfc_hostname
    username_claim                = "sub"
    groups_claim                  = "terraform_organization_name"
  }
}

resource "aws_eks_identity_provider_config" "oidc_config_vso_csi" {
  count = var.enable_vso_csi_cluster ? 1 : 0

  cluster_name = module.eks_vso_csi[0].cluster_name

  oidc {
    identity_provider_config_name = "tfstack-terraform-cloud"
    client_id                     = var.tfc_kubernetes_audience
    issuer_url                    = var.tfc_hostname
    username_claim                = "sub"
    groups_claim                  = "terraform_organization_name"
  }
}

data "aws_eks_cluster_auth" "vso" {
  count = var.enable_vso_cluster ? 1 : 0

  name = module.eks_vso[0].cluster_name
}

data "aws_eks_cluster_auth" "vso_csi" {
  count = var.enable_vso_csi_cluster ? 1 : 0

  name = module.eks_vso_csi[0].cluster_name
}
