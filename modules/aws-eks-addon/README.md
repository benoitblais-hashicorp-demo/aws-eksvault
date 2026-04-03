# AWS EKS Add-on Terraform module

This module installs and manages core EKS add-ons and AWS Load Balancer Controller for an existing EKS cluster.

## Permissions

Required access for caller identities:

- AWS IAM baseline:
  - `eks:DescribeCluster`, `eks:DescribeAddonVersions`, `eks:CreateAddon`, `eks:UpdateAddon`, `eks:DeleteAddon`.
  - IAM for controller integration: `iam:CreateRole`, `iam:DeleteRole`, `iam:AttachRolePolicy`, `iam:DetachRolePolicy`, `iam:PassRole`, `iam:GetRole`, `iam:TagRole`.
  - Supporting reads: `ec2:Describe*`, `elasticloadbalancing:Describe*`, `acm:ListCertificates`, `acm:DescribeCertificate`.
- Kubernetes RBAC for the Kubernetes provider identity:
  - API groups/resources/verbs at cluster scope sufficient to create service accounts, cluster roles, cluster role bindings, roles, role bindings, services, deployments, daemonsets, configmaps, and validating webhooks.
  - Practical baseline for demo: cluster-admin.
- Helm provider uses the same Kubernetes RBAC scope as above.

## Authentication

This module uses AWS, Kubernetes, and Helm providers passed from the caller.

## Features

- Manages key EKS add-ons such as CoreDNS, VPC CNI, and kube-proxy.
- Installs AWS Load Balancer Controller.
- Supports Fargate-oriented add-on settings.

## Usage example

```hcl
module "eks_addons" {
  source = "./modules/aws-eks-addon"

  cluster_certificate_authority_data = "BASE64_CA"
  cluster_endpoint                   = "https://example.eks.amazonaws.com"
  cluster_name                       = "eks-ca-vso"
  cluster_version                    = "1.30"
  oidc_binding_id                    = "rbac-binding-id"
  oidc_provider_arn                  = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.region.amazonaws.com/id/example"
  vpc_id                             = "vpc-123456"
}
```

## Documentation

## Requirements

The following requirements are needed by this module:

- terraform (~> 1.14)

## Providers

No providers.

## Modules

The following Modules are called:

### eks\_blueprints\_addons

Source: aws-ia/eks-blueprints-addons/aws

Version: ~> 1.23

## Resources

No resources.

## Required Inputs

The following input variables are required:

### cluster\_certificate\_authority\_data

Description: (Required) Base64-encoded cluster certificate authority data.

Type: `string`

### cluster\_endpoint

Description: (Required) Kubernetes API server endpoint URL.

Type: `string`

### cluster\_name

Description: (Required) EKS cluster name.

Type: `string`

### cluster\_version

Description: (Required) Kubernetes version used by the EKS cluster.

Type: `string`

### oidc\_binding\_id

Description: (Required) OIDC binding identifier used for component dependency ordering.

Type: `string`

### oidc\_provider\_arn

Description: (Required) OIDC provider ARN associated with the EKS cluster.

Type: `string`

### vpc\_id

Description: (Required) VPC identifier where EKS resources are deployed.

Type: `string`

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### argo\_workflows

Description: Map of attributes for the Argo Workflows Helm release.

### aws\_load\_balancer\_controller

Description: Map of attributes for the AWS Load Balancer Controller Helm release and IRSA resources.

### eks\_addons

Description: Map of attributes for enabled EKS add-ons.
