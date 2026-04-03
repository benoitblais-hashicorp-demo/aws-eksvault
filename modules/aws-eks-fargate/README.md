# AWS EKS Fargate Terraform module

This module provisions an EKS control plane with Fargate profiles and optional cluster administrator access mapping.

## Permissions

Required AWS IAM access for the caller identity:

- AWS managed policy baseline: `AdministratorAccess` for labs, or a scoped set combining:
  - `AmazonEKSClusterPolicy`.
  - `AmazonEKSFargatePodExecutionRolePolicy`.
  - `IAMFullAccess` limited to module-created roles/policies if possible.
  - CloudWatch Logs permissions for EKS log groups.
- If using least privilege, include at minimum actions across:
  - EKS: `eks:CreateCluster`, `eks:DeleteCluster`, `eks:DescribeCluster`, `eks:CreateFargateProfile`, `eks:DeleteFargateProfile`, `eks:DescribeFargateProfile`, `eks:TagResource`, `eks:UntagResource`, `eks:CreateAccessEntry`, `eks:AssociateAccessPolicy`.
  - IAM: `iam:CreateRole`, `iam:DeleteRole`, `iam:AttachRolePolicy`, `iam:DetachRolePolicy`, `iam:PassRole`, `iam:TagRole`, `iam:CreateOpenIDConnectProvider`, `iam:GetRole`, `iam:ListAttachedRolePolicies`.
  - Logs: `logs:CreateLogGroup`, `logs:PutRetentionPolicy`, `logs:DescribeLogGroups`.
  - EC2 read access for cluster networking metadata: `ec2:Describe*`.

## Authentication

This module uses AWS provider authentication from the caller and configures Kubernetes access through generated cluster endpoint, CA data, and token outputs.

## Features

- Creates an EKS cluster with IRSA enabled.
- Configures Fargate profiles for system and application namespaces.
- Supports optional IAM cluster-admin role creation or existing IAM principal mapping.
- Exposes EKS connection outputs for downstream Kubernetes and Helm providers.

## Usage example

```hcl
module "eks_fargate" {
  source = "./modules/aws-eks-fargate"

  cluster_name             = "eks-ca-vso"
  kubernetes_version       = "1.30"
  private_subnets          = ["subnet-123", "subnet-456"]
  tfc_kubernetes_audience  = "k8s.workload.identity"
  vpc_id                   = "vpc-123456"
}
```

## Documentation

## Requirements

The following requirements are needed by this module:

- terraform (~> 1.14)

- aws (~> 5.0)

## Providers

The following providers are used by this module:

- aws (~> 5.0)

## Modules

The following Modules are called:

### eks

Source: terraform-aws-modules/eks/aws

Version: 20.2.0

## Resources

The following resources are used by this module:

- [aws_eks_identity_provider_config.oidc_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_identity_provider_config) (resource)
- [aws_iam_role.eks_clusteradmin](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) (resource)
- [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) (data source)
- [aws_eks_cluster.upstream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) (data source)
- [aws_eks_cluster_auth.upstream_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) (data source)

## Required Inputs

The following input variables are required:

### kubernetes\_version

Description: (Required) Kubernetes version used by the EKS cluster.

Type: `string`

### private\_subnets

Description: (Required) Private subnet identifiers used by the EKS cluster.

Type: `list(string)`

### tfc\_kubernetes\_audience

Description: (Required) Audience used for Kubernetes OIDC authentication.

Type: `string`

### vpc\_id

Description: (Required) VPC identifier where EKS resources are deployed.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### cluster\_name

Description: (Optional) EKS cluster name.

Type: `string`

Default: `"eks-cluster"`

### clusteradmin\_role\_name

Description: (Optional) IAM role name for cluster admin access when role creation is enabled.

Type: `string`

Default: `""`

### create\_clusteradmin\_role

Description: (Optional) Whether to create a new IAM role for cluster admin access.

Type: `bool`

Default: `false`

### eks\_clusteradmin\_arn

Description: (Optional) Existing IAM role or user ARN used for cluster admin access.

Type: `string`

Default: `""`

### eks\_clusteradmin\_username

Description: (Optional) Username mapped to cluster admin access when using an existing IAM principal.

Type: `string`

Default: `""`

### region

Description: (Optional) AWS region used for helper output generation.

Type: `string`

Default: `"ap-southeast-2"`

### tfc\_hostname

Description: (Optional) Terraform Cloud or Terraform Enterprise hostname.

Type: `string`

Default: `"https://app.terraform.io"`

## Outputs

The following outputs are exported:

### cluster\_certificate\_authority\_data

Description: Base64-encoded certificate authority data for the EKS cluster.

### cluster\_endpoint

Description: Endpoint URL for the EKS cluster API server.

### cluster\_name

Description: Name of the EKS cluster.

### cluster\_version

Description: Kubernetes version of the EKS cluster.

### clusteradmin\_role\_arn

Description: ARN of the cluster admin IAM role when created.

### clusteradmin\_role\_name

Description: Name of the cluster admin IAM role when created or provided.

### configure\_kubectl

Description: Command to update kubeconfig for the EKS cluster.

### eks\_token

Description: Authentication token for connecting to the EKS cluster.

### oidc\_provider\_arn

Description: OIDC provider ARN associated with the EKS cluster.
